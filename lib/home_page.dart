import 'package:flutter/material.dart';
import 'home/cart.dart';
import 'home/search.dart';
import 'home/profile.dart';
import 'home/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSelectedIndex = 0;

  final _pages = [
    Home(),
    Profile(),
    Cart(),
    Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F5C5A),
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
        onTap: (newIndex) {
          setState(() {
            _currentSelectedIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: IconTheme(
                data: IconThemeData(),
                child: Icon(Icons.home_outlined),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: IconTheme(
                data: IconThemeData(),
                child: Icon(Icons.person_outline),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: IconTheme(
                data: IconThemeData(),
                child: Icon(Icons.card_travel),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: IconTheme(
                data: IconThemeData(),
                child: Icon(Icons.search),
              ),
              label: ''),
        ],
      ),
    );
  }
}
