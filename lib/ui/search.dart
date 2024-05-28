import 'package:flutter/material.dart';
import '../api/tvmaze_api.dart';
import 'show_info.dart'; // Assurez-vous d'importer le fichier show_info.dart

class SearchPage extends StatefulWidget {
  final String title;

  const SearchPage({Key? key, required this.title}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchShows(String query) async {
    setState(() {
      _isLoading = true;
    });

    final api = TvMazeApi();
    final response = await api.searchShows(query);

    setState(() {
      _searchResults = response;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un titre',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchShows(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                _searchShows(query);
              },
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : _searchResults.isEmpty
                ? Text('Aucun résultat trouvé')
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final show = _searchResults[index]['show'];
                  final imageUrl = show['image'] != null ? show['image']['medium'] : null;
                  return Card(
                    child: ListTile(
                      leading: imageUrl != null
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Icon(Icons.broken_image);
                        },
                      )
                          : Icon(Icons.broken_image),
                      title: Text(show['name']),
                      subtitle: show['summary'] != null
                          ? Text(show['summary'].replaceAll(RegExp(r'<[^>]*>'), ''))
                          : Text('Aucune description'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowInfoPage(show: show),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
