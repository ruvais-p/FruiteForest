import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/analysis_page/bloc/analysis_bloc.dart';
import 'package:fruiteforest/feature/analysis_page/config/analysis_config.dart';
import 'package:fruiteforest/feature/analysis_page/presentation/widgets/activity_heat_map_widget.dart';
import 'package:fruiteforest/feature/analysis_page/presentation/widgets/category_pie_chart_widget.dart';

/// Analysis Page
///
/// Displays user activity analytics including:
/// - Activity heatmap calendar showing daily engagement
/// - Category distribution pie chart
///
/// ## Configuration
/// Thresholds and colors can be customized via [AnalysisConfig].
/// See `config/analysis_config.dart` for details.
class AnalysisPage extends StatelessWidget {
  /// Optional custom configuration for charts
  final AnalysisConfig? config;

  const AnalysisPage({super.key, this.config});

  @override
  Widget build(BuildContext context) {
    final chartConfig = config ?? AnalysisConfig.defaults();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Text("Analysis", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Activity Heatmap Section ───
                Text(
                  "Activity Heatmap",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ActivityHeatMap(
                    data: state.dailyMinutes,
                    config: chartConfig,
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Category Distribution Section ───
                Text(
                  "Category Distribution",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CategoryPieChart(
                    data: state.categoryMinutes,
                    config: chartConfig,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
