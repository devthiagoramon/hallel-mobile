import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class DrawerRoutesModel {
  String title;
  Icons icon;

  DrawerRoutesModel({required this.title, required this.icon});
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: HomeContainer(),
      drawer: Drawer(
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
