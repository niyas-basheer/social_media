
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_server_app/features/app/home/home_page.dart';
import 'package:test_server_app/features/app/splash/splash_screen.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/login/login_cubit.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/user/user_cubit.dart';
import 'package:test_server_app/features/app/user/user_injection_container.dart';
import 'package:test_server_app/firebase_options.dart';

import 'package:test_server_app/routes/on_generate_routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
await FirebaseAppCheck.instance.activate( androidProvider: AndroidProvider.playIntegrity,);
  userInjectionContainer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sl = GetIt.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider(
          create: (context) => sl<CredentialCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<GetSingleUserCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<GetDeviceNumberCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<LoginCubit>(),
        ),
        // BlocProvider(
        //   create: (context) => di.sl<ChatCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => di.sl<MessageCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => di.sl<StatusCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => di.sl<GetMyStatusCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => di.sl<CallCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => di.sl<MyCallHistoryCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => di.sl<AgoraCubit>(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: tabColor,
              brightness: Brightness.dark
          ),
          scaffoldBackgroundColor: backgroundColor,
          dialogBackgroundColor: appBarColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
          ),
        ),
        initialRoute: "/",
        onGenerateRoute: OnGenerateRoute.route,
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomePage(uid: authState.uid, );
                }
                return const SplashScreen();
              },
            );
          },
        },
      ),
    );
  }
}
