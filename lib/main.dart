import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/theme/app_theme_cubit.dart';
import 'package:contact_list/data/repositories/user_repository.dart';
import 'package:contact_list/logic/auth/auth_bloc.dart';
import 'package:contact_list/logic/call/call_bloc.dart';
import 'package:contact_list/logic/contact/contact_bloc.dart';
import 'package:contact_list/presentation/screens/login_screen.dart';
import 'package:contact_list/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  final userRepository = UserRepository();

  runApp(MyApp(userRepository: userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(userRepository)),
        BlocProvider(create: (_) => ContactBloc(userRepository)),
        BlocProvider(create: (_) => CallBloc(userRepository)),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter BLoC Demo',
            theme: theme,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('vi')],
            initialRoute: "/",
            routes: {
              "/": (context) => LoginScreen(),
              "/main": (context) => MainScreen(),
            },
          );
        },
      ),
    );
  }
}
