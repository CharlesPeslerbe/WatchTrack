import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          // Photo de profil
          CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(''),
        ),
        SizedBox(height: 16),
        // Nom d'utilisateur
        Text(
          "Nom d'utilisateur",
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      // Statistiques
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nombre de séries suivies
          Column(
            children: [
              Text(
                '123',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Séries',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          // Nombre d'épisodes vus
          Column(
            children: [
              Text(
                '456',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Épisodes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          // Nombre de jours passés à regarder des séries
          Column(
            children: [
              Text(
                '789',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Jours',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 16),
      // Boutons de connexion aux réseaux sociaux
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bouton de connexion à Facebook
          IconButton(
            icon: Icon(Icons.facebook),
            color: Colors.blue,
            onPressed: () {},
          ),
          SizedBox(width: 16),
          // Bouton de connexion à Twitter
          IconButton(
            icon: Icon(Icons.add_box),
            color: Colors.grey,
            onPressed: () {},
          ),
          SizedBox(width: 16),
          // Bouton de connexion à Instagram
          IconButton(
            icon: Icon(Icons.add_box),
            color: Colors.pink,
            onPressed: () {},
          ),
        ],
      ),
      SizedBox(height: 16),
      // Bouton de déconnexion
      ElevatedButton(
        onPressed: () {},
        child: Text('Déconnexion'),
      ),
      ],
    ),
    ),
    );
  }
}
