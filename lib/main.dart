import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_todo_app/blocs/schedule/schedule_bloc.dart';
import 'package:my_todo_app/repositories/schedule_repository.dart';
import 'package:my_todo_app/screens/profile_page/profile_page.dart';
import 'package:my_todo_app/screens/register_page/register_screen.dart';
import 'package:my_todo_app/screens/theme/theme_notifier.dart';
import 'package:my_todo_app/utils/notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'blocs/auth/bloc.dart';
import 'blocs/user/bloc.dart';
import 'utils/api_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';
import 'screens/login_page/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/theme/theme.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- ${bloc.runtimeType}, ${transition.currentState} to ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('onError -- ${bloc.runtimeType}, $error');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  final themeNotifier = await ThemeNotifier.load();

  final navigatorKey = GlobalKey<NavigatorState>();
  final apiService = ApiService(baseUrl: 'http://100.117.159.20:3333', navigatorKey: navigatorKey);

  await NotificationService.init();
  tz.initializeTimeZones();

  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
  if(success) {
    FlutterBackground.enableBackgroundExecution();
  }
  log(success.toString());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => themeNotifier,
        ),
        Provider<ApiService>.value(value: apiService),
        ProxyProvider<ApiService, AuthRepository>(
          update: (context, apiService, _) => AuthRepository(apiService: apiService),
        ),
        ProxyProvider<ApiService, UserRepository>(
          update: (context, apiService, _) => UserRepository(apiService: apiService),
        ),
        ProxyProvider<ApiService, ScheduleRepository>(
          update: (context, apiService, _) => ScheduleRepository(apiService: apiService),
        ),
      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  MyApp({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            userRepository: Provider.of<UserRepository>(context, listen: false),
          ),
        ),
        BlocProvider<ScheduleBloc>(
          create: (context) => ScheduleBloc(
            scheduleRepository: Provider.of<ScheduleRepository>(context, listen: false),
          ),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: Provider.of<AuthRepository>(context, listen: false),
            scheduleBloc: Provider.of<ScheduleBloc>(context, listen: false),
            userBloc: BlocProvider.of<UserBloc>(context, listen: false),
            apiService: Provider.of<ApiService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: themeNotifier.lightTheme,
        darkTheme: themeNotifier.darkTheme,
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ru', 'RU'),
        ],
        routes: {
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/main': (context) => MainPage(),
          '/profile': (context) => ProfilePage(),
        },
        home: AuthChecker(),
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return MainPage();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
