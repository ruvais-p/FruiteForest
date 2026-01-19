import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/theme/app_theme/app_theme.dart';
import 'package:fruiteforest/feature/analysis_page/bloc/analysis_bloc.dart';
import 'package:fruiteforest/feature/auth/presentation/splashscreen/splash_screen.dart';
import 'package:fruiteforest/feature/auth/bloc/auth_bloc.dart';
import 'package:fruiteforest/feature/auth/presentation/welcome_page/welcome_page.dart';
import 'package:fruiteforest/feature/auth/repository/auth_repository.dart';
import 'package:fruiteforest/feature/homepage/bloc/home_bloc.dart';
import 'package:fruiteforest/feature/homepage/repository/home_repository.dart';
import 'package:fruiteforest/feature/store/bloc/store_bloc.dart';
import 'package:fruiteforest/feature/store/repository/store_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iatrojsqevuyuuvaeacm.supabase.co',
    anonKey: 'sb_publishable_Kkn7vGRUEYWDNLtTSbx8aw_JvAk_MHy',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              AuthBloc(AuthRepository(supabase))..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(HomeRepository())..add(HomeStarted()),
        ),
        BlocProvider<AnalysisBloc>(
          create: (context) =>
              AnalysisBloc(Supabase.instance.client)..add(LoadAnalysis()),
        ),
        BlocProvider<StoreBloc>(
          create: (_) => StoreBloc(StoreRepository())..add(LoadStore()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightMode,
        home: WelcomePage(),
      ),
    );
  }
}
