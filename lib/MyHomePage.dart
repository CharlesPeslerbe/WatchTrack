import 'package:flutter/material.dart';
import 'ui/discover.dart';
import 'ui/watchlist.dart';
import 'ui/search.dart';
import 'ui/account.dart';

class MyHomePage extends StatefulWidget {
  final String initialTitle;

  // Constructeur avec initialTitle par défaut
  MyHomePage({Key? key, this.initialTitle = 'Titre par défaut'}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // Liste des pages affichées dans le corps de l'application
  final List<Widget> _pages = [
    DiscoverPage(title: "Discover"),
    WatchlistPage(title: "Watchlist"),
    SearchPage(title: "Search"),
    AccountPage(title: "Account"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTitle),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedItemColor: Colors.white30,
        unselectedLabelStyle: TextStyle(color: Colors.white30),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dvr),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}