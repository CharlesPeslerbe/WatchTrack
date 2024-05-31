import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadJson(Map<String, dynamic> jsonData, String filePath) async {
    final String jsonString = jsonEncode(jsonData);
    final Reference ref = _storage.ref().child(filePath);
    await ref.putString(jsonString, format: PutStringFormat.raw);
  }

  Future<Map<String, dynamic>> downloadJson(String filePath) async {
    final Reference ref = _storage.ref().child(filePath);
    final url = await ref.getDownloadURL();
    final response = await http.get(Uri.parse(url));

    final String jsonString = response.body;
    return jsonDecode(jsonString);
  }

  Future<void> markEpisodeAsWatched(String uid, Map<String, dynamic> episodeData, Map<String, dynamic> showData) async {
    final String filePath = '$uid/episodes.json';
    Map<String, dynamic> existingData;

    try {
      existingData = await downloadJson(filePath);
    } catch (e) {
      // Si le fichier n'existe pas, on créé un nouveau fichier
      existingData = {'shows': []};
    }

    // On cherche si la série existe déjà dans le fichier
    final showIndex = existingData['shows'].indexWhere((show) => show['id'] == showData['id']);
    // Si la série n'existe pas, on la créer
    if (showIndex == -1) {
      // On ajoute les données de l'épisode
      showData['watchedEpisodes'] = [episodeData];
      // On ajoute les données la série
      existingData['shows'].add(showData);
    }
    // Si la série existe déjà
    else {
      // On récupère les données de la série
      final show = existingData['shows'][showIndex];
      // On cherche si un épisode existe déjà dans la série
      if (show['watchedEpisodes'].isEmpty) {
        show['watchedEpisodes'].add(episodeData);
      } else {
        final currentEpisode = show['watchedEpisodes'].first;
        // Comparer les épisodes par saison et numéro pour déterminer le plus récent
        if ((episodeData['season'] > currentEpisode['season']) ||
            (episodeData['season'] == currentEpisode['season'] && episodeData['number'] > currentEpisode['number'])) {
          // Remplacer par l'épisode plus récent
          show['watchedEpisodes'][0] = episodeData;
        }
      }
    }
    // Envoyer les données
    await uploadJson(existingData, filePath);
  }
}
