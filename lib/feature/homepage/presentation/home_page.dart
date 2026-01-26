import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruiteforest/feature/homepage/bloc/home_bloc.dart';
import 'package:fruiteforest/feature/homepage/model/activity_category_model.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/activity_category_selector.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/app_drawer_widget.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/drawer_button.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/point_widget.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/start_button_widget.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          key: _scaffoldKey,
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 🔹 TOP BAR
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 40,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppDrawerButton(scaffoldKey: _scaffoldKey),
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (p, c) => p.points != c.points,
                        builder: (context, state) {
                          return PointWidget(point: state.points);
                        },
                      ),
                    ],
                  ),
                ),

                // 🔹 CENTER CONTENT
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.586,
                  child: SvgPicture.asset('assets/images/tree.svg'),
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (!state.hasStarted) {
                      return Column(
                        children: [
                          Text(
                            "Start your productive day",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (p, c) => p.category != c.category,
                  builder: (context, state) {
                    if (state.hasStarted) return const SizedBox();

                    return ActivityCategorySelector(
                      selected: state.category ?? ActivityCategory.focus,
                      onChanged: (cat) {
                        context.read<HomeBloc>().add(CategorySelected(cat));
                      },
                    );
                  },
                ),

                // 🔹 TIMER / START BUTTON
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (!state.hasStarted) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),

                          StartButton(
                            onPressed: state.category == null
                                ? null
                                : () => context.read<HomeBloc>().add(
                                    TimerStart(),
                                  ),
                          ),
                        ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
