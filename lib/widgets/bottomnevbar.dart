
import 'package:budget_odc/Page/budget_page/budget_page.dart';
import 'package:budget_odc/Page/graphique_page/graphique_page.dart';
import 'package:budget_odc/Page/home_Page/home_page.dart';
import 'package:budget_odc/Page/profil_page/profil_page.dart';
import 'package:budget_odc/theme/couleur.dart';
import 'package:flutter/material.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomePage(),
    GraphiquePage(),
    BudgetPage(),
    ProfilPage()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Graphique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: vert,
        unselectedItemColor: noir,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
   