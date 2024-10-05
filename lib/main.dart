import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hallel/screens/configs/drawer_home_config.dart';
import 'package:hallel/screens/configs/tabs_config_home.dart';
import 'package:hallel/screens/home/home.dart';
import 'package:hallel/screens/home/quem-somos.dart';
import 'package:hallel/screens/login.dart';
import 'package:hallel/screens/profile/profile.dart';
import 'package:hallel/screens/signin.dart';
import 'package:hallel/services/dio_client.dart';
import 'package:hallel/services/user_service/user_api_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var initialRoute = "/";

void main() {
  runApp(const MainApp());
}

final _router = GoRouter(initialLocation: initialRoute, routes: [
  GoRoute(path: "/", builder: (context, state) => const MainContainer()),
  GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
  GoRoute(path: "/signin", builder: (context, state) => const SignInScreen()),
  ShellRoute(
    builder: (context, state, child) {
      return TabsLayout(child: child);
    },
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return HomeLayout(child: child);
          },
          routes: [
            GoRoute(
                path: "/home",
                name: "home",
                builder: (context, state) => const HomeScreen()),
            GoRoute(
                path: "/home/quem-somos",
                builder: (context, state) => const QuemSomosScreen(),
                name: "home-quem-somos"),
          ]),
      GoRoute(
        path: "/profile",
        name: "profile",
        builder: (context, state) => const ProfileScreen(),
      )
    ],
  )
]);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp.router(
        title: 'Hallel',
        routerConfig: _router,
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      ),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({
    super.key,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<void> validateTokenUser() async {
      final prefs = await SharedPreferences.getInstance();
      final tokenApi = prefs.getString("tokenApi");
      if (tokenApi != null && tokenApi.isNotEmpty) {
        DioClient().setTokenApi(tokenApi);
        try {
          final tokenValid =
              await UserRoutesApi().validateTokenUserService(tokenApi);
          if (!mounted) return;
          if (tokenValid) {
            context.go("/home");
          } else {
            context.go("/login");
          }
        } catch (e) {
          log(e.toString(), name: "MainPage");
        }
      }
    }

    validateTokenUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final TextStyle titleStyle = theme.textTheme.displaySmall!.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold);

    return Scaffold(
      body: Column(
        children: [
          ImageContainerMainPage(),
          CardMainPage(theme: theme, titleStyle: titleStyle)
        ],
      ),
    );
  }
}

class CardMainPage extends StatelessWidget {
  const CardMainPage({
    super.key,
    required this.theme,
    required this.titleStyle,
  });

  final ThemeData theme;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.primaryColor,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(24), bottom: Radius.zero)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  "Olá, seja bem vindo",
                  style: titleStyle,
                )
              ],
            ),
            SizedBox(
              height: 28,
            ),
            ButtonsCardMainPage()
          ],
        ),
      ),
    );
  }
}

class ButtonsCardMainPage extends StatelessWidget {
  const ButtonsCardMainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonText =
        theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            context.go("/signin");
          },
          style: FilledButton.styleFrom(minimumSize: Size(500, 46)),
          child: Text(
            "CADASTRO",
            style: buttonText,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FilledButton(
            onPressed: () {
              context.go("/login");
            },
            style: FilledButton.styleFrom(
                backgroundColor: Colors.blue, minimumSize: Size(500, 46)),
            child: Text(
              "ENTRAR",
              style: buttonText.copyWith(color: Colors.white),
            )),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class ImageContainerMainPage extends StatelessWidget {
  const ImageContainerMainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/images/logo_hallel.png",
              width: 200,
              height: 130,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {}
