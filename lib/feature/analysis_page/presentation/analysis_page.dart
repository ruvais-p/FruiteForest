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
      appBar: AppBar(title: const Text("Analysis")),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Activity Heatmap",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ActivityHeatMap(data: state.dailyMinutes),

                const SizedBox(height: 30),

                const Text(
                  "Category Distribution",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 250,
                  child: CategoryPieChart(data: state.categoryMinutes),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
