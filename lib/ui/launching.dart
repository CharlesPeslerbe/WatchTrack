import 'package:flutter/material.dart';
import 'login.dart';

class LaunchingPage extends StatefulWidget {
  @override
  _LaunchingPageState createState() => _LaunchingPageState();
}

class _LaunchingPageState extends State<LaunchingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Envelopper la colonne dans un widget Center pour la centrer horizontalement
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Afficher le logo de l'application
            Image.asset(
              'assets/logo.jpg',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 200), // Ajouter un peu d'espace entre le logo et le CircularProgressIndicator
            // Afficher le CircularProgressIndicator
            SizedBox(
              width: 50.0, // Largeur du CircularProgressIndicator
              height: 50.0, // Hauteur du CircularProgressIndicator
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
