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
      // On cherche si l'épisode existe déjà dans la série
      final episodeIndex = show['watchedEpisodes'].indexWhere((episode) => episode['id'] == episodeData['id']);
      // Si l'épisode n'existe pas, on l'ajoute
      if (episodeIndex == -1) {
        show['watchedEpisodes'].add(episodeData);
      }
      // Si l'épisode existe, on test si l'épisode est plus récent
      else {
        // Si l'épisode est plus récent, on le supprime et on met à jour les données

        show['watchedEpisodes'][episodeIndex] = episodeData;
        // Si l'épisode est moins récent, on annule

      }
    }
    // Envoyer les données
    await uploadJson(existingData, filePath);
  }
}
