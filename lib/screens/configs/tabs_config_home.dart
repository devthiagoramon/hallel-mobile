import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabsLayoutModel {
  String label;
  IconData icon;
  String route;

  TabsLayoutModel(
      {required this.label, required this.icon, required this.route});
}

class TabsLayout extends StatelessWidget {
  final Widget child;

  TabsLayout({super.key, required this.child});

  final List<TabsLayoutModel> _tabsRoutes = [
    TabsLayoutModel(label: "Inicio", icon: Icons.home, route: "/home"),
    TabsLayoutModel(label: "Perfil", icon: Icons.person, route: "/profile")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          onTap: (int index) {
            context.go(_tabsRoutes[index].route);
          },
          items: _tabsRoutes.map((route) {
            return BottomNavigationBarItem(
                icon: Icon(route.icon), label: route.label);
          }).toList()),
    );
  }
}
