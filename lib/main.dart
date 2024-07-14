import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/bloc.dart';
import 'blocs/user/bloc.dart';
import 'repositories/api_service.dart';
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

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  final ApiService apiService = ApiService(baseUrl: 'http://10.0.2.2:3333');
  final AuthRepository authRepository = AuthRepository(apiService: apiService);
  final UserRepository userRepository = UserRepository(apiService: apiService);

  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(authRepository: authRepository, userRepository: userRepository, apiService: apiService));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final ApiService apiService;

  MyApp({required this.authRepository, required this.userRepository, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository, userBloc: BlocProvider.of<UserBloc>(context), apiService: apiService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Меняет тему в зависимости от системной темы
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
          return MainPage(); // Показываем MainPage для авторизованного пользователя
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

