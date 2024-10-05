import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabsLayoutModel {
  String label;
  IconData icon;
  String route;

  TabsLayoutModel(
      {required this.label, required this.icon, required this.route});
}

class TabsLayout extends StatefulWidget {
  final Widget child;

  TabsLayout({super.key, required this.child});

  @override
  State<TabsLayout> createState() => _TabsLayoutState();
}

class _TabsLayoutState extends State<TabsLayout> {
  final List<TabsLayoutModel> _tabsRoutes = [
    TabsLayoutModel(label: "Inicio", icon: Icons.home, route: "/home"),
    TabsLayoutModel(label: "Perfil", icon: Icons.person, route: "/profile")
  ];

  var currentIndexTab = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _updateCurrentIndex(context);
  }

  void _updateCurrentIndex(BuildContext context) {
    final currentRoute =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    final index =
        _tabsRoutes.indexWhere((tab) => currentRoute.startsWith(tab.route));
    if (index != -1 && index != currentIndexTab) {
      setState(() {
        currentIndexTab = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateCurrentIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          currentIndex: currentIndexTab,
          onTap: (int index) {
            setState(() {
              currentIndexTab = index;
            });
            context.go(_tabsRoutes[index].route);
          },
          items: _tabsRoutes.map((route) {
            return BottomNavigationBarItem(
                icon: Icon(route.icon), label: route.label);
          }).toList()),
    );
  }
}
