import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/helper/go_router_helper.dart';
import 'package:goods/ui/blocs/asset/asset_screen_bloc.dart';
import 'package:goods/ui/blocs/home/home_screen_bloc.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/common_top_bar_widget.dart';
import 'package:goods/ui/widgets/primary_icon_button_widget.dart';
import 'package:goods/ui/widgets/search_text_field_widget.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({super.key});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      context.read<AssetScreenBloc>().add(FetchDataEvent());
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AssetScreenBloc>().add(FetchDataEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // 90% of max scroll
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      context.read<AssetScreenBloc>().add(OnSearchEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        if (state is HomeScreenLogOuted) {
          // navigate to login screen
          // using go router
          context.goNamed(AppRoute.login.name);
        }
      },
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<HomeScreenBloc, HomeScreenState>(
            builder: (context, state) {
              if (state is HomeScreenLoaded) {
                return CommonTopBar(
                  username: state.userDetail.username,
                  email: state.userDetail.email,
                );
              } else {
                return CommonTopBar(username: '', email: '');
              }
            },
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'List Asset',
              style: titleMedium.copyWith(color: grey800),
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchTextField(onChangedEvent: _onSearchChanged),
          ),
          const SizedBox(height: 12.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: grey100,
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<AssetScreenBloc>().add(RefreshDataEvent());
              },
              child: _buildAssetList(),
            ),
            constraints: BoxConstraints(maxHeight: 500),
          ),
          const SizedBox(height: 64.0),
        ],
      ),
    );
  }

  Widget _buildAssetList() {
    return BlocBuilder<AssetScreenBloc, AssetScreenState>(
      builder: (context, state) {
        switch (state.status) {
          case AssetStatus.failure:
            return Center(child: Text('Error: ${state.errorMessage}'));

          case AssetStatus.success:
            if (state.assets.isEmpty) {
              return const Center(child: Text('No assets found'));
            }
            return ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.assets.length
                  : state.assets.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.assets.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final asset = state.assets[index];
                return _listItem(asset.id, asset.name);
              },
            );

          case AssetStatus.initial:
          case AssetStatus.loading:
            // show loading indicator at center if initial loading
            if (state.assets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            // if not initial loading, show the list with loading indicator at bottom
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.assets.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.assets.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final asset = state.assets[index];
                return _listItem(asset.id, asset.name);
              },
            );
        }
      },
    );
  }

  Widget _listItem(String id, String name) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: grey200, width: 1.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asset Name', style: labelLarge.copyWith(color: grey700)),
              const SizedBox(height: 4.0),
              Text(name, style: titleSmall.copyWith(color: grey800)),
            ],
          ),

          PrimaryIconButton(
            onPressed: () {
              context.goNamed(
                AppRoute.editAsset.name,
                pathParameters: {'id': id},
              );
            },
            child: Icon(Icons.edit, color: grey100),
          ),
        ],
      ),
    );
  }
}
