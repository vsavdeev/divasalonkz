import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../services/services_screen.dart';
import '../favourites/favourites_screen.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ServicesPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var mainArea = Container(
      color: Colors.black,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: _pages[_selectedIndex],
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 450;
          return isMobile
              ? Column(
                  children: [
                    Expanded(child: SafeArea(child: mainArea)),
                    CustomNavigation(
                      isMobile: true,
                      selectedIndex: _selectedIndex,
                      onSelect: (index) =>
                          setState(() => _selectedIndex = index),
                    ),
                  ],
                )
              : Row(
                  children: [
                    CustomNavigation(
                      isMobile: false,
                      selectedIndex: _selectedIndex,
                      onSelect: (index) =>
                          setState(() => _selectedIndex = index),
                      isExtended: constraints.maxWidth >= 600,
                    ),
                    Expanded(child: SafeArea(child: mainArea)),
                  ],
                );
        },
      ),
    );
  }
}

class CustomNavigation extends StatelessWidget {
  final bool isMobile;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool isExtended;

  const CustomNavigation({
    required this.isMobile,
    required this.selectedIndex,
    required this.onSelect,
    this.isExtended = false,
  });

  static const List<NavigationItem> _items = [
    NavigationItem(icon: Icons.home, label: 'Главная'),
    NavigationItem(icon: Icons.list, label: 'Услуги'),
    NavigationItem(icon: Icons.favorite, label: 'Избранное'),
  ];

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.grey,
            currentIndex: selectedIndex,
            onTap: (index) {
              if (index < _items.length) {
                onSelect(index);
              }
            },
            items: _items
                .map((item) => BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      label: item.label,
                    ))
                .toList(),
          )
        : NavigationRail(
            backgroundColor: Colors.black,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              if (index < _items.length) {
                onSelect(index);
              }
            },
            extended: isExtended,
            selectedLabelTextStyle: TextStyle(color: Colors.pink),
            unselectedLabelTextStyle: TextStyle(color: Colors.grey),
            destinations: _items
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon, color: Colors.grey),
                      selectedIcon: Icon(item.icon, color: Colors.pink),
                      label: Text(item.label),
                    ))
                .toList(),
          );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  const NavigationItem({required this.icon, required this.label});
}
