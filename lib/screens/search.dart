import 'package:fakeflix/screens/details.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  String query = '';
  bool isLoading = false;

  Future<void> searchMovies(String searchQuery) async {
    setState(() {
      isLoading = true; // Show loading indicator when fetching results
    });

    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$searchQuery'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = jsonDecode(response.body);
        isLoading = false; // Hide loading indicator after fetching results
      });
    } else {
      setState(() {
        isLoading = false; // Hide loading in case of error
      });
      throw Exception('Failed to fetch search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search for movies...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            setState(() {
              query = value;
            });
            searchMovies(value);
          },
        ),
      ),
      body: query.isEmpty
          ? const Center(child: Text('Enter a search term', style: TextStyle(color: Colors.white)))
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          // Determine the number of columns based on the screen width
          int crossAxisCount = 3; // Default for smaller screens
          if (constraints.maxWidth >= 1200) {
            crossAxisCount = 5; // For large screens (desktops)
          } else if (constraints.maxWidth >= 800) {
            crossAxisCount = 4; // For tablets and medium-sized screens
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Adjust based on screen width
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7, // Aspect ratio for poster dimensions
            ),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final movie = searchResults[index]['show'];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(movie: movie),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: movie['image'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          movie['image']['medium'],
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      movie['name'],
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
