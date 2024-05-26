import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/launching.dart';
import 'ui/discover.dart';
import 'ui/watchlist.dart';
import 'ui/search.dart';
import 'ui/account.dart';
import 'ui/login.dart';

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
      themeMode: ThemeMode.dark, // Use dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => LaunchingPage(), // Initial home screen
        '/discover': (context) => DiscoverPage(title: 'Discover'), // Discover page
        '/watchlist': (context) => WatchlistPage(title: 'Watchlist'), // Watchlist page
        '/search': (context) => SearchPage(title: 'Search'), // Search page
        '/account': (context) => AccountPage(title: 'Account'), // Account page
        '/login': (context) => LoginPage(), // Add login screen route
      },
    );
  }
}
