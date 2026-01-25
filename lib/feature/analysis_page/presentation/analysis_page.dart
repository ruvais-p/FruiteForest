import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/analysis_page/bloc/analysis_bloc.dart';
import 'package:fruiteforest/feature/analysis_page/presentation/widgets/activity_heat_map_widget.dart';
import 'package:fruiteforest/feature/analysis_page/presentation/widgets/category_pie_chart_widget.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analysis",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // 🔹 Activity Heatmap Section
                Text(
                  "Activity Heatmap",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ActivityHeatMap(data: state.dailyMinutes),

                const SizedBox(height: 40),

                // 🔹 Category Distribution Section
                Text(
                  "Category Distribution",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: CategoryPieChart(data: state.categoryMinutes),
                ),

                // 🔹 Category Legend with colors
                const SizedBox(height: 16),
                _buildCategoryLegend(state.categoryMinutes),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryLegend(Map<String, double> data) {
    final entries = data.entries.toList();

    return Wrap(
      spacing: 20,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: entries.asMap().entries.map((mapEntry) {
        final index = mapEntry.key;
        final entry = mapEntry.value;
        final color = CategoryPieChart.getColorForCategory(entry.key, index);
        final label = CategoryPieChart.getCategoryLabel(entry.key);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}
