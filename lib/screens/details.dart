import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final Map movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie['image']?['original'];
    final genres = movie['genres'] != null ? (movie['genres'] as List).join(", ") : 'Unknown';
    final rating = movie['rating']?['average']?.toString() ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['name']),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster with Full Image
            imageUrl != null
                ? Stack(
              alignment: Alignment.center,
              children: [
                // Loading placeholder
                Container(
                  color: Colors.black12,
                  height: 400,
                  width: double.infinity,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                // Full-size image
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Make image cover its space
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Render image when fully loaded
                    }
                    return const SizedBox.shrink(); // While loading, hide image
                  },
                ),
              ],
            )
                : Container(
              height: 400,
              width: double.infinity,
              color: Colors.grey[800],
              child: const Icon(
                Icons.image_not_supported,
                size: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Movie Title
            Text(
              movie['name'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Genres and Rating
            Row(
              children: [
                if (genres.isNotEmpty)
                  Chip(
                    label: Text(
                      genres,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(
                    '⭐ $rating',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Summary
            Text(
              movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No Summary Available',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),

            // Additional Details
            const Divider(color: Colors.white54),
            _buildDetailItem('Type', movie['type']),
            _buildDetailItem('Language', movie['language']),
            _buildDetailItem('Status', movie['status']),
            _buildDetailItem('Runtime', '${movie['runtime'] ?? "Unknown"} min'),
            _buildDetailItem('Average Runtime', '${movie['averageRuntime'] ?? "Unknown"} min'),
            _buildDetailItem('Official Site', movie['officialSite']),
            const Divider(color: Colors.white54),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Netflix-like dark theme
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: label == 'Official Site' && value != null
                ? GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(value);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print("Could not launch $value");
                  // Optionally show a Snackbar or other UI to inform the user
                }
              },
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
                : Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
