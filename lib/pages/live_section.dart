import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/services/api_service.dart';

class LiveSection extends StatefulWidget {
  const LiveSection({super.key});

  @override
  State<LiveSection> createState() => _LiveSectionState();
}

class _LiveSectionState extends State<LiveSection> {
  Future<List<Map<String, dynamic>>>? _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = api.getAllPostsWithUsernames();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.cadetGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text('Live Feed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No posts found.'));
            } else {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Card(
                    elevation: 3,
                    color: AppColors.softWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person),
                                      Text(
                                        post["userName"],
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: _width * 0.2,
                                decoration: BoxDecoration(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      post["likes"].toString(),
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onDoubleTap: () {
                            api.toggleLike(post['postId']);
                            setState(() {
                              post['likes'] = post['likes'] + 1;
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    post['imagePath'],
                                    height: _height * 0.3,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(
                                      0.5), // Semi-transparent background
                                  height: _height *
                                      0.1, // Height of the description line
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        post[
                                            'description'], // Your description text
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 14, // Font size
                                          fontWeight:
                                              FontWeight.bold, // Font weight
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
