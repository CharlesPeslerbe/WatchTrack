import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/discover.dart';
import 'ui/watchlist.dart';
import 'ui/search.dart';
import 'ui/account.dart';
import 'ui/login.dart';
import 'ui/launching.dart';
import 'ui/create_account.dart';
import 'MyHomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bottom Navigation Bar',
      // Dark Theme
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LaunchingPage(), // Page de lancement
        '/home': (context) => MyHomePage(initialTitle: 'Home'), // Page d'accueil avec barre de navigation
        '/discover': (context) => DiscoverPage(title: 'Discover'), // Page Discover
        '/watchlist': (context) => WatchlistPage(title: 'Watchlist'), // Page Watchlist
        '/search': (context) => SearchPage(title: 'Search'), // Page Search
        '/account': (context) => AccountPage(title: 'Account'), // Page Account
        '/login': (context) => LoginPage(), // Page de connexion
        '/create_account': (context) => CreateAccountPage(), // Page de création de compte
      },
    );
  }
}
