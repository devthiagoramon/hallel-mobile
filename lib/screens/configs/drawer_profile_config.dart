import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileLayout extends StatefulWidget {
  final Widget child;
  const ProfileLayout({super.key, required this.child});

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class DrawerRoutesModel {
  String title;
  IconData icon;
  String route;

  DrawerRoutesModel(
      {required this.title, required this.icon, required this.route});
}

class _ProfileLayoutState extends State<ProfileLayout> {
  int selectedIndex = 0;

  List<DrawerRoutesModel> _homepageRoutes = [
    DrawerRoutesModel(title: "Perfil", icon: Icons.person, route: "/profile"),
    DrawerRoutesModel(
        title: "Associação",
        icon: Icons.assignment,
        route: "/profile/associacao")
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 72,
        shape: BorderDirectional(
            bottom: BorderSide(color: Colors.black, width: 1)),
        leading: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                iconSize: 32,
                icon: Icon(Icons.menu)),
          );
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
                selectedIndex = index;
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}