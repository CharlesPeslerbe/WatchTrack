import 'package:flutter/material.dart';
import '../api/tvmaze_api.dart'; // Assurez-vous que l'import est correct

class EpisodeDetailPage extends StatelessWidget {
  final int episodeId;

  const EpisodeDetailPage({Key? key, required this.episodeId}) : super(key: key);

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
                    episode['name'],
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
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
