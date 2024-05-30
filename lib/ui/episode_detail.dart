import 'package:flutter/material.dart';
import '../api/tvmaze_api.dart';
import '../storage/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EpisodeDetailPage extends StatelessWidget {
  final int episodeId;
  final int showId;
  final String showName;
  final String showGenre;
  final FirebaseStorageService _storageService;

  EpisodeDetailPage({
    Key? key,
    required this.episodeId,
    required this.showId,
    required this.showName,
    required this.showGenre,
  })  : _storageService = FirebaseStorageService(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = TvMazeApi();

    return Scaffold(
      appBar: AppBar(
        title: Text('Episode Details'),
      ),
      body: FutureBuilder<dynamic>(
        future: api.getEpisodeDetails(episodeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final episode = snapshot.data!;
            final imageUrl = episode['image'] != null ? episode['image']['original'] : null;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )
                      : SizedBox(height: 200, child: Center(child: Text('No Image Available'))),
                  SizedBox(height: 16.0),
                  Text(
                    episode['name'] ?? 'No name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Season ${episode['season']} Episode ${episode['number']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    episode['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No description available',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          final episodeData = {
                            'id': episode['id'],
                            'name': episode['name'],
                            'season': episode['season'],
                            'number': episode['number'],
                          };
                          final showData = {
                            'id': showId, // Utilizing showId
                            'name': showName, // Passing showName
                            'genre': showGenre, // Passing showGenre
                          };
                          await _storageService.markEpisodeAsWatched(user.uid, episodeData, showData);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Episode marked as watched!'),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error: ${e.toString()}'),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User not authenticated'),
                        ));
                      }
                    },
                    child: Text('Mark as Watched'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
