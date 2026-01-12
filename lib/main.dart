import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/auth/presentation/splashscreen/splash_screen.dart';
import 'package:fruiteforest/feature/auth/bloc/auth_bloc.dart';
import 'package:fruiteforest/feature/auth/repository/auth_repository.dart';
import 'package:fruiteforest/feature/homepage/bloc/home_bloc.dart';
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
        BlocProvider(create: (_) => HomeBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
