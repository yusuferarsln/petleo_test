import 'package:flutter/material.dart';
import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/extensions/content_extension.dart';
import 'package:petleo_test/firebase/firebase_authentication.dart';
import 'package:petleo_test/pages/sign_in_page.dart';
import 'package:petleo_test/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Map<String, dynamic>>>? _postsFuture;
  Future<String>? _userFuture;

  bool isGridView = true;
  @override
  void initState() {
    super.initState();
    _postsFuture = api.getUserPosts(auth.authFuuid());
    _userFuture = api.getUserDetail(auth.authFuuid());
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.cadmiumGreen,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.cadmiumGreen,
        actions: [
          IconButton(
            onPressed: () {
              auth.authSignOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: FutureBuilder<String>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found.'));
          } else {
            final userName = snapshot.data!;
            return Column(
              children: [
                Container(
                  height: _height * 0.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isGridView ? Icons.view_list : Icons.grid_view,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isGridView ? buildGridView() : buildListView(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildGridView() {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: context.height * 0.7,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    post['imagePath'],
                                    fit: BoxFit.cover,
                                    height: context.height * 0.3,
                                    width: context.width * 0.8,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: 20,
                                    ),
                                    Text(post['likes'].toString())
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  post['description'] ?? 'No description',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Image.network(
                  post['imagePath'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget buildListView() {
    final _height = MediaQuery.of(context).size.height;

    return FutureBuilder<List<Map<String, dynamic>>>(
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

              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: context.height * 0.7,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    post['imagePath'],
                                    fit: BoxFit.cover,
                                    height: context.height * 0.3,
                                    width: context.width * 0.8,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: 20,
                                    ),
                                    Text(post['likes'].toString())
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  post['description'] ?? 'No description',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    post['imagePath'],
                    height: _height * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
