import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatefulWidget {
  final Widget child;
  const HomeLayout({super.key, required this.child});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class DrawerRoutesModel {
  String title;
  IconData icon;
  String route;

  DrawerRoutesModel(
      {required this.title, required this.icon, required this.route});
}

class _HomeLayoutState extends State<HomeLayout> {
  int selected_index = 0;

  List<DrawerRoutesModel> _homepageRoutes = [
    DrawerRoutesModel(title: "Inicio", icon: Icons.home, route: "/home"),
    DrawerRoutesModel(
        title: "Quem somos", icon: Icons.church, route: "/home/quem-somos")
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_homepageRoutes[selected_index].title),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu));
        }),
      ),
      body: widget.child,
      drawer: Drawer(
        child: ListView.builder(
          itemCount: _homepageRoutes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_homepageRoutes[index].title),
              leading: Icon(_homepageRoutes[index].icon),
              onTap: () {
                context.go(_homepageRoutes[index].route);
                selected_index = index;
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
