import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/domain/models/common_model.dart';
import 'package:goods/ui/blocs/asset/asset_screen_bloc.dart';
import 'package:goods/ui/blocs/edit/edit_asset_screen_bloc.dart';
import 'package:goods/ui/screens/error_screen.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/autocomplete_text_form_field_widget.dart';
import 'package:goods/ui/widgets/general_text_form_field_widget.dart';
import 'package:goods/ui/widgets/primary_button_widget.dart';
import 'package:goods/ui/widgets/secondary_button_widget.dart';
import 'package:goods/utils/utils.dart';

class EditAssetScreen extends StatefulWidget {
  final String assetId;

  const EditAssetScreen({super.key, required this.assetId});

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _assetNameController;
  late final TextEditingController _statusController;
  late final TextEditingController _locationController;

  String? _selectedStatusId;
  String? _selectedLocationId;

  bool _isDataInitialized = false;
  List<CommonModel> _statuses = [];
  List<CommonModel> _locations = [];

  @override
  void initState() {
    super.initState();
    _assetNameController = TextEditingController();
    _statusController = TextEditingController();
    _locationController = TextEditingController();

    context.read<EditAssetScreenBloc>().add(FetchAllDataEvent(widget.assetId));
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey200,
        appBar: AppBar(
          backgroundColor: grey100,
          centerTitle: true,
          title: Text('Edit Asset', style: titleLarge.copyWith(color: grey800)),
          leading: BackButton(color: grey800),
        ),
        body: BlocConsumer<EditAssetScreenBloc, EditAssetScreenState>(
          listener: (context, state) async {
            if (state is EditAssetScreenLoaded && !_isDataInitialized) {
              _assetNameController.text = state.asset.name;
              _statusController.text = state.asset.status.name;
              _locationController.text = state.asset.location.name;
              _selectedStatusId = state.asset.status.id;
              _selectedLocationId = state.asset.location.id;
              _statuses = state.statuses;
              _locations = state.locations;
              _isDataInitialized = true;
            }

            if (state is EditAssetScreenDeleteSuccess) {
              context.read<AssetScreenBloc>().add(RefreshDataEvent());
              await showSuccessDialog(
                context: context,
                title: 'Success!',
                message: 'Data has been deleted.',
              );
              context.pop();
            } else if (state is EditAssetScreenUpdateSuccess) {
              context.read<AssetScreenBloc>().add(RefreshDataEvent());
              await showSuccessDialog(
                context: context,
                title: 'Success!',
                message: 'Data has been updated.',
              );
              context.pop();
            }
          },
          builder: (context, state) {
            if (!_isDataInitialized) {
              if (state is EditAssetScreenError) {
                return ErrorScreen(
                  message: state.message,
                  onRetry: () {
                    context.read<EditAssetScreenBloc>().add(
                      FetchAllDataEvent(widget.assetId),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22, top: 18),
                          child: Text(
                            'Edit this form\nbelow',
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
                                  suggestions: _statuses,
                                  onSuggestionSelected: (String selection) {
                                    setState(() {
                                      _selectedStatusId = selection;
                                      _statusController.text = _statuses
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
                                    if (!_statuses.any(
                                      (e) => e.name == value,
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
                                  suggestions: _locations,
                                  onSuggestionSelected: (String selection) {
                                    setState(() {
                                      _selectedLocationId = selection;
                                      _locationController.text = _locations
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
                                    if (!_locations.any(
                                      (e) => e.name == value,
                                    )) {
                                      return 'Please select a valid location from the list.';
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 36,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          width: double.infinity,
                          onPressed: () {
                            showNormalDialog(
                              context: context,
                              title: 'Confirmation',
                              message:
                                  'Your action will cause this data\npermanently deleted.',
                              primaryButtonText: 'Delete',
                              onPrimaryButtonPressed: () {
                                context.read<EditAssetScreenBloc>().add(
                                  DeleteAssetEvent(widget.assetId),
                                );
                              },
                              secondaryButtonText: 'Cancel',
                            );
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          width: double.infinity,
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _selectedLocationId != null &&
                                _selectedStatusId != null) {
                              context.read<EditAssetScreenBloc>().add(
                                UpdateAssetEvent(
                                  assetId: widget.assetId,
                                  name: _assetNameController.text,
                                  statusId: _selectedStatusId!,
                                  locationId: _selectedLocationId!,
                                ),
                              );
                            }
                          },
                          child: const Text('Save Update'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
