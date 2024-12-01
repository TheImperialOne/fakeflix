import 'package:fakeflix/screens/details.dart';
import 'package:fakeflix/screens/search.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];
  bool isLoading = false; // To track if data is being loaded
  int page = 1; // To track the current page
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMovies(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Load more movies when the user reaches the bottom
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          page++;
          fetchMovies(page);
        }
      }
    });
  }

  Future<void> fetchMovies(int page) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all&page=$page'));
    if (response.statusCode == 200) {
      setState(() {
        movies.addAll(jsonDecode(response.body)); // Add new movies to the list
        isLoading = false; // Reset loading state
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/fakeflix_logo.png', // Replace with your image path
          width: 30, // Set the width of the image
          height: 30, // Set the height of the image
        ),
        title: const SizedBox.shrink(), // Hides any text in the title area
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: movies.isEmpty
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
            controller: _scrollController, // Attach ScrollController
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Adjust the number of columns based on screen width
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7, // Aspect ratio for poster dimensions
            ),
            itemCount: movies.length + (isLoading ? 1 : 0), // Add loading indicator if needed
            itemBuilder: (context, index) {
              if (index == movies.length) {
                // Display loading indicator at the bottom
                return const Center(child: CircularProgressIndicator());
              }
              final movie = movies[index]['show'];
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
