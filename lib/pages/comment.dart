import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Comment extends StatefulWidget {
  final String postId;
  const Comment({super.key, required this.postId});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final TextEditingController _commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance;

  Future<void> postComment() async {
    final text = _commentController.text.trim();

    if (text.isEmpty || currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Comment cannot be empty or user not logged in."),
        ),
      );
      return;
    }

    final commentData = {
      'text': text,
      'uid': currentUser!.uid,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      await database
          .ref('posts/${widget.postId}/comments')
          .push()
          .set(commentData);

      _commentController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Comment posted!")));
    } catch (e) {
      print("Error posting comment: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to post comment")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsRef = database.ref('posts/${widget.postId}/comments');

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3D62),
        title: const Text(
          "Comments",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: commentsRef.onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(
                    child: Text(
                      "No comments yet.",
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                }

                final commentsMap = Map<String, dynamic>.from(
                  snapshot.data!.snapshot.value as Map,
                );

                final commentsList =
                    commentsMap.entries.map((entry) {
                        final comment = Map<String, dynamic>.from(entry.value);
                        comment['id'] = entry.key;
                        return comment;
                      }).toList()
                      ..sort(
                        (a, b) => b['timestamp'].compareTo(a['timestamp']),
                      );

                return ListView.builder(
                  itemCount: commentsList.length,
                  itemBuilder: (context, index) {
                    final comment = commentsList[index];
                    return ListTile(
                      title: Text(
                        comment['text'] ?? '',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      subtitle: Text(
                        comment['timestamp'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Write a comment...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.grey),
                  onPressed: postComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
