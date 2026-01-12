import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/homepage/bloc/home_bloc.dart';
import 'package:fruiteforest/feature/homepage/presentation/widget/timer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isRunning = context.read<HomeBloc>().state.isRunning;

        if (isRunning) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Stop the timer before leaving'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        return !isRunning;
      },

      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                /// 🔹 Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.analytics),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {},
                    ),
                    Text(
                      "0 Points",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.green),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔹 Center content
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

                /// 🔹 Timer
                const SizedBox(height: 20),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return SimpleTimerWidget(
                      seconds: state.seconds,
                      isRunning: state.isRunning,
                      onStart: () => context.read<HomeBloc>().add(TimerStart()),
                      onPause: () => context.read<HomeBloc>().add(TimerPause()),
                      onStop: () => context.read<HomeBloc>().add(TimerStop()),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
