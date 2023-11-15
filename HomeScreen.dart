import 'package:barter/Screens/HomeScreen/MiPerfilTab.dart';
import 'package:flutter/material.dart';
import '../CentroDeCambioTab.dart';
import 'MisObjetosTab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    MiPerfilTab(),
    CentroDeCambios(),
    MisObjetosTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barter App'),
        backgroundColor: Color(0xff471f53),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Centro de Cambio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Mis Objectos',
          ),
        ],
      ),
    );
  }
}