import 'package:flutter/material.dart';

class AwarenessPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': 'Safety Tips for Women',
      'thumbnail': 'https://www.goaid.in/wp-content/uploads/2024/05/Womens-Safety-in-India.png',
    },
    {
      'title': 'Self-Defense Techniques',
      'thumbnail': 'https://static.wixstatic.com/media/ff1c35_13ea0865e8854ff5ae11a8df5ed74724~mv2.jpg/v1/fill/w_568,h_318,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/ff1c35_13ea0865e8854ff5ae11a8df5ed74724~mv2.jpg',
    },
    {
      'title': 'Recognizing Dangerous Situations',
      'thumbnail': 'https://cdn.educba.com/academy/wp-content/uploads/2023/12/Safety-of-Women-in-India.jpg',
    },
    {
      'title': 'Safety Tips for Women',
      'thumbnail': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAsYjRK7fvrUT3636STrYYGj5aGn5P8FNDjg&s',
    },
    {
      'title': 'Self-Defense Techniques',
      'thumbnail': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTSLGPnytG-Y7GfTrYsaeR_onl3PewbCffeg&s'
    },
    {
      'title': 'Recognizing Dangerous Situations',
      'thumbnail': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-1pGyLusrPyi-NgYxsdioIrpLTlUCsYuTQg&s'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awareness'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.network(
                      video['thumbnail']!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Title and metadata
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.visibility, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              '1.2M views',
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            const Spacer(),
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              '10:25',
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
