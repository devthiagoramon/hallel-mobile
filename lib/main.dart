import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hallel',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: MainContainer(),
    );
  }
}

class MainContainer extends StatelessWidget {
  const MainContainer({
    super.key,
  });

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
        SizedBox(
          width: 500,
          height: 46,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              "CADASTRO",
              style: buttonText,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
            width: 500,
            height: 46,
            child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  "ENTRAR",
                  style: buttonText.copyWith(color: Colors.white),
                ))),
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
