import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'add_page.dart';
import 'comment.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  List<Map<dynamic, dynamic>> posts = [];
  List<bool> likedStates = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final ref = FirebaseDatabase.instance.ref().child('posts');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final Map data = snapshot.value as Map;
      final List<Map<dynamic, dynamic>> loadedPosts = [];

      data.forEach((key, value) {
        final postWithId = Map<String, dynamic>.from(value);
        postWithId['id'] = key;
        loadedPosts.add(postWithId);
      });

      setState(() {
        posts = loadedPosts.reversed.toList();
        likedStates = List.generate(loadedPosts.length, (_) => false);
      });
    }
  }

  Uint8List? decodeImage(String? base64Image) {
    if (base64Image == null) return null;
    try {
      return base64Decode(base64Image);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3), // soft off-white
      appBar: AppBar(
        backgroundColor: const Color(0xFF023D54), // deep blue
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Travel Feed",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchPosts,
        child:
            posts.isEmpty
                ? ListView(
                  children: const [
                    SizedBox(height: 150),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.travel_explore,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "No posts yet!",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final image = decodeImage(post['imageBase64']);
                    final isLiked = likedStates[index];

                    return GestureDetector(
                      onTap: () {
                        if (image != null) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: InteractiveViewer(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(image),
                                    ),
                                  ),
                                ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (image != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.memory(
                                  image,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post['placeName'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    post['cityName'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    post['caption'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            likedStates[index] = !isLiked;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              "Like",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => Comment(
                                                    postId: post['id'],
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.comment,
                                              color: Color(
                                                0xFF023D54,
                                              ), // Deep Blue
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "Comment",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF023D54), // Deep blue
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
          fetchPosts();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
