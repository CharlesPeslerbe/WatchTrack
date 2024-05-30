import 'dart:convert';
import 'package:http/http.dart' as http;

class TvMazeApi {
  static const String _baseUrl = 'https://api.tvmaze.com';

  // Requête de recherche d'une série
  Future<List<dynamic>> searchShows(String query) async {
    // Envoi de la requête
    final response = await http.get(Uri.parse('$_baseUrl/search/shows?q=$query'));
    // Si la requête est correcte
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    }
    // Gestion de l'erreur
    else {
      throw Exception('Failed to load data');
    }
  }

  // Requête d'infos sur une série précise ( grâce à son ID )
  Future<dynamic> getShowDetails(int showId) async {
    // Envoi de la requête
    final response = await http.get(Uri.parse('$_baseUrl/shows/$showId'));
    // Si la requête est correcte
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    }
    // Gestion de l'erreur
    else {
      throw Exception('Failed to load data');
    }
  }

  // Requête des saisons d'une série
  Future<List<dynamic>> getSeasons(int showId) async {
    // Envoi de la requête
    final response = await http.get(Uri.parse('$_baseUrl/shows/$showId/seasons'));
    // Si la requête est correcte
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    }
    // Gestion de l'erreur
    else {
      throw Exception('Failed to load seasons');
    }
  }

  // Requête des épisodes d'une saison
  Future<List<dynamic>> getEpisodes(int seasonId) async {
    // Envoi de la requête
    final response = await http.get(Uri.parse('$_baseUrl/seasons/$seasonId/episodes'));
    // Si la requête est correcte
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    }
    // Gestion de l'erreur
    else {
      throw Exception('Failed to load episodes');
    }
  }

  // Requête des détails d'un épisode
  Future<dynamic> getEpisodeDetails(int episodeId) async {
    // Envoi de la requête
    final response = await http.get(Uri.parse('$_baseUrl/episodes/$episodeId'));
    // Si la requête est correcte
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    }
    // Gestion de l'erreur
    else {
      throw Exception('Failed to load episode details');
    }
  }

}
