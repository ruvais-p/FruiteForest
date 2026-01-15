import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/analysis_page/presentation/analysis_page.dart';
import 'package:fruiteforest/feature/homepage/bloc/home_bloc.dart';
import 'package:fruiteforest/feature/homepage/model/activity_category_model.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/timer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeStarted());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isRunning = context.read<HomeBloc>().state.isRunning;

        if (isRunning) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Stop the timer before leaving'),
                duration: Duration(seconds: 2),
              ),
            );
        }
        return !isRunning;
      },
      child: BlocListener<HomeBloc, HomeState>(
        listenWhen: (p, c) => c.showCompletionDialog && !p.showCompletionDialog,
        listener: (context, state) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('🎉 Congratulations'),
              content: const Text('You have successfully completed a session.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // 🔹 TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.analytics),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AnalysisPage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {},
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (p, c) => p.points != c.points,
                        builder: (context, state) {
                          return Text(
                            "${state.points} Points",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: Colors.green),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 CENTER CONTENT
                  Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Welcome to Fruite Forest!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 CATEGORY DROPDOWN (only before start)
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (p, c) => p.category != c.category,
                    builder: (context, state) {
                      if (state.hasStarted) return const SizedBox();

                      return DropdownButton<ActivityCategory>(
                        isExpanded: true,
                        hint: const Text("Select Category"),
                        value: state.category,
                        items: ActivityCategory.values.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat.label),
                          );
                        }).toList(),
                        onChanged: (cat) {
                          if (cat != null) {
                            context.read<HomeBloc>().add(CategorySelected(cat));
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // 🔹 TIMER / START BUTTON
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (!state.hasStarted) {
                        return ElevatedButton(
                          onPressed: state.category == null
                              ? null
                              : () =>
                                    context.read<HomeBloc>().add(TimerStart()),
                          child: const Text("Start"),
                        );
                      }

                      return CountdownWidget(
                        seconds: state.seconds,
                        category: state.category!,
                        onGiveUp: () =>
                            context.read<HomeBloc>().add(TimerGiveUp()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
