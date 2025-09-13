import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/di/injection.dart';
import 'package:goods/helper/go_router_helper.dart';
import 'package:goods/helper/workmanager_helper.dart';
import 'package:goods/ui/blocs/home/home_screen_bloc.dart';
import 'package:goods/ui/screens/asset_screen.dart';
import 'package:goods/ui/screens/error_screen.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/common_top_bar_widget.dart';
import 'package:goods/ui/widgets/fab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [HomeScreenFragment(), AssetScreen()];

  // handle bottom nav tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      context.read<HomeScreenBloc>().add(FetchHomeDataEvent());

      await getIt<WorkmanagerHelper>().runPeriodicTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey200,
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Asset'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: primary800,
          unselectedItemColor: grey800,
          onTap: _onItemTapped,
        ),
        floatingActionButton: PrimaryFab(
          child: const Icon(Icons.add, color: grey100),
          onPressed: () {
            // navigate to input asset screen
            // using go router
            context.goNamed(AppRoute.inputAsset.name);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class HomeScreenFragment extends StatefulWidget {
  const HomeScreenFragment({super.key});

  @override
  State<HomeScreenFragment> createState() => _HomeScreenFragmentState();
}

class _HomeScreenFragmentState extends State<HomeScreenFragment> {
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
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is HomeScreenLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeScreenLoaded) {
          final statusData = state.aggAssetByStatus.results
              .map(
                (status) => {
                  'title': status.status.name,
                  'value': status.count.toString(),
                },
              )
              .toList();
          final locationData = state.aggAssetByLocation.results
              .map(
                (location) => {
                  'title': location.location.name,
                  'value': location.count.toString(),
                },
              )
              .toList();

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonTopBar(
                  username: state.userDetail.username,
                  email: state.userDetail.email,
                ),
                const SizedBox(height: 16.0),
                _buildHomeSection('Status', statusData, const {
                  'Asset': teal500,
                  'Sold': orange500,
                  'Stock': red300,
                }),
                const SizedBox(height: 16.0),
                _buildHomeSection('Location', locationData, const {
                  'Gudang': teal500,
                  'Rak Penjualan': orange500,
                }),
                const SizedBox(height: 64.0),
              ],
            ),
          );
        } else if (state is HomeScreenError) {
          return ErrorScreen(
            message: state.message,
            onRetry: () {
              context.read<HomeScreenBloc>().add(FetchHomeDataEvent());
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildHomeSection(
    String title,
    List<Map<String, String>> dataList,
    Map<String, Color> colors,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleMedium.copyWith(color: grey800)),
          const SizedBox(height: 6.0),
          LayoutBuilder(
            builder: (context, constraints) {
              // determine items per row based on available width
              // max 3 items per row
              final int itemsPerRow = (dataList.length >= 3 || dataList.isEmpty)
                  ? 3
                  : dataList.length;
              final double spacing = 8.0 * (itemsPerRow - 1);
              final double cardWidth =
                  (constraints.maxWidth - spacing) / itemsPerRow;

              return Wrap(
                spacing: 8.0, // horizontal spacing between items
                runSpacing: 8.0, // vertical spacing between rows
                children: dataList.map((data) {
                  return SizedBox(
                    width: cardWidth,
                    child: _buildSummaryCard(data['title']!, data['value']!),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 4.0),
          _buildBarChart(
            // convert dataList to Map<String, double>
            data: dataList.asMap().map(
              (_, data) => MapEntry(
                data['title']!,
                double.tryParse(data['value']!) ?? 0,
              ),
            ),
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Card(
      color: grey100,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: titleSmall.copyWith(color: grey700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(value, style: headlineMedium2.copyWith(color: grey800)),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart({
    required Map<String, double> data,
    required Map<String, Color> colors,
  }) {
    // each entry in data map becomes a BarChartGroupData
    // with x as index and y as value
    // color is taken from colors map
    final barGroups = data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final dataEntry = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dataEntry.value,
            color: colors[dataEntry.key],
            width: 25,
            borderRadius: const BorderRadius.all(Radius.circular(0)),
          ),
        ],
      );
    }).toList();

    // determine max value from data for y-axis scaling
    final double maxDataValue = data.values.reduce(max);
    final double tempInterval = maxDataValue > 0
        ? (maxDataValue / 4).ceilToDouble()
        : 2;
    final double yInterval = tempInterval == 0 ? 1 : tempInterval;
    final double dynamicMaxValue =
        (maxDataValue / yInterval).ceil() * yInterval;

    return Card(
      color: grey100,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chart', style: titleSmall.copyWith(color: grey800)),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  maxY: dynamicMaxValue,
                  barGroups: barGroups,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: grey300, strokeWidth: 1);
                    },
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(y: 0, color: grey300, strokeWidth: 1),
                      HorizontalLine(
                        y: dynamicMaxValue,
                        color: grey300,
                        strokeWidth: 1,
                      ),
                    ],
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: yInterval,
                        getTitlesWidget: (value, meta) {
                          // hide label if value exceeds dynamicMaxValue
                          if (value > dynamicMaxValue) return const Text('');
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(color: grey700, fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // custom legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.keys
                  .map((key) => _buildLegendItem(colors[key]!, key))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // custom legend item
  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(text, style: labelSmall.copyWith(color: grey800)),
        ],
      ),
    );
  }
}
