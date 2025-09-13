import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/ui/blocs/asset/asset_screen_bloc.dart';
import 'package:goods/ui/blocs/input/input_asset_screen_bloc.dart';
import 'package:goods/ui/screens/error_screen.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/autocomplete_text_form_field_widget.dart';
import 'package:goods/ui/widgets/general_text_form_field_widget.dart';
import 'package:goods/ui/widgets/primary_button_widget.dart';
import 'package:goods/utils/utils.dart';

class InputAssetScreen extends StatefulWidget {
  const InputAssetScreen({super.key});

  @override
  State<InputAssetScreen> createState() => _InputAssetScreenState();
}

class _InputAssetScreenState extends State<InputAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _assetNameController;
  late final TextEditingController _statusController;
  late final TextEditingController _locationController;

  String? _selectedStatusId;
  String? _selectedLocationId;

  @override
  void initState() {
    super.initState();
    _assetNameController = TextEditingController();
    _statusController = TextEditingController();
    _locationController = TextEditingController();

    Future.microtask(() {
      context.read<InputAssetScreenBloc>().add(FetchStatusAndLocationEvent());
    });
  }

  @override
  void dispose() {
    _assetNameController.dispose();
    _statusController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InputAssetScreenBloc, InputAssetScreenState>(
      listener: (context, state) {
        if (state is InputAssetScreenSuccess) {
          // refresh asset list
          // show success message
          // navigate back to previous screen
          context.read<AssetScreenBloc>().add(FetchDataEvent());
          showSuccessSnackBar(context, 'Asset created successfully');
          context.pop();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: grey200,
          appBar: AppBar(
            backgroundColor: grey100,
            centerTitle: true,
            title: Text(
              'Input Asset',
              style: titleLarge.copyWith(color: grey800),
            ),
            leading: BackButton(color: grey800),
          ),
          body: BlocBuilder<InputAssetScreenBloc, InputAssetScreenState>(
            builder: (context, state) {
              if (state is InputAssetScreenLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is InputAssetScreenError) {
                return ErrorScreen(
                  message: state.message,
                  onRetry: () {
                    context.read<InputAssetScreenBloc>().add(
                      FetchStatusAndLocationEvent(),
                    );
                  },
                );
              } else if (state is InputAssetScreenLoaded) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22, top: 18),
                          child: Text(
                            'Fill this form\nbelow',
                            style: headlineMedium1.copyWith(color: grey800),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Asset Name',
                                  style: labelLarge.copyWith(color: grey800),
                                ),
                                const SizedBox(height: 8),
                                GeneralTextFormField(
                                  controller: _assetNameController,
                                  hintText: 'Input name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This form is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Status',
                                  style: labelLarge.copyWith(color: grey800),
                                ),
                                const SizedBox(height: 8),
                                AutocompleteTextFormField(
                                  controller: _statusController,
                                  hintText: 'Select status',
                                  suggestions: state.statuses,
                                  onSuggestionSelected: (String selection) {
                                    // set selected status id
                                    setState(() {
                                      _selectedStatusId = selection;

                                      _statusController.text = state.statuses
                                          .firstWhere(
                                            (element) =>
                                                element.id == selection,
                                          )
                                          .name;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This form is required';
                                    }
                                    // only allow values from the predefined list
                                    if (!state.statuses.any(
                                      (element) => element.name == value,
                                    )) {
                                      return 'Please select a valid status from the list.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Location',
                                  style: labelLarge.copyWith(color: grey800),
                                ),
                                const SizedBox(height: 8),
                                AutocompleteTextFormField(
                                  controller: _locationController,
                                  hintText: 'Select location',
                                  suggestions: state.locations,
                                  onSuggestionSelected: (String selection) {
                                    // set selected location id
                                    setState(() {
                                      _selectedLocationId = selection;

                                      _locationController.text = state.locations
                                          .firstWhere(
                                            (element) =>
                                                element.id == selection,
                                          )
                                          .name;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This form is required';
                                    }
                                    // only allow values from the predefined list
                                    if (!state.locations.any(
                                      (element) => element.name == value,
                                    )) {
                                      return 'Please select a valid status from the list.';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 36,
                      ),
                      child:
                          BlocBuilder<
                            InputAssetScreenBloc,
                            InputAssetScreenState
                          >(
                            builder: (context, state) {
                              if (state is InputAssetScreenSubmitLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return PrimaryButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate() &&
                                        _selectedLocationId != null &&
                                        _selectedStatusId != null) {
                                      context.read<InputAssetScreenBloc>().add(
                                        OnSubmitButtonPressedEvent(
                                          name: _assetNameController.text,
                                          statusId: _selectedStatusId!,
                                          locationId: _selectedLocationId!,
                                        ),
                                      );
                                    }
                                  },
                                  width: double.infinity,
                                  child: Text('Submit'),
                                );
                              }
                            },
                          ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
