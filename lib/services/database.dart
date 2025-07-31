// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Add a post with auto-generated ID
//   Future<void> addPost(Map<String, dynamic> postInfoMap) async {
//     try {
//       await _firestore.collection('Posts').add(postInfoMap);
//     } catch (e) {
//       print('Error adding post: $e');
//       rethrow; // let caller handle if needed
//     }
//   }

//   // Get posts stream ordered by timestamp descending
//   Stream<QuerySnapshot> getPosts() {
//     return _firestore
//         .collection('Posts')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   // Optional: Add user details
//   Future<void> addUserDetails(
//     Map<String, dynamic> userInfoMap,
//     String id,
//   ) async {
//     await _firestore.collection('users').doc(id).set(userInfoMap);
//   }

//   // Optional: Get user by email
//   Future<QuerySnapshot> getUserByEmail(String email) async {
//     return await _firestore
//         .collection('users')
//         .where('Email', isEqualTo: email)
//         .get();
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Add a post with auto-generated ID
//   Future<void> addPost(Map<String, dynamic> postInfoMap) async {
//     try {
//       print('Saving post data: $postInfoMap'); // Debug print
//       await _firestore.collection('Posts').add(postInfoMap);
//     } catch (e) {
//       print('Error adding post: $e');
//       rethrow;
//     }
//   }

//   // Get posts stream ordered by timestamp descending
//   Stream<QuerySnapshot> getPosts() {
//     return _firestore
//         .collection('Posts')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   // Optional: Add user details
//   Future<void> addUserDetails(
//     Map<String, dynamic> userInfoMap,
//     String id,
//   ) async {
//     await _firestore.collection('users').doc(id).set(userInfoMap);
//   }

//   // Optional: Get user by email
//   Future<QuerySnapshot> getUserByEmail(String email) async {
//     return await _firestore
//         .collection('users')
//         .where('email', isEqualTo: email) // lowercase field
//         .get();
//   }
// }

//---------------------new code---------------------------

// import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
// import 'package:firebase_database/firebase_database.dart' as realtime;

// class DatabaseMethods {
//   final firestore.FirebaseFirestore _firestore =
//       firestore.FirebaseFirestore.instance;
//   final realtime.DatabaseReference _realtimeDbRef =
//       realtime.FirebaseDatabase.instance.ref();

//   Future<void> addUserDetails(
//     String userId,
//     Map<String, dynamic> userInfoMap,
//   ) async {
//     await _firestore
//         .collection('users')
//         .doc(userId)
//         .set(userInfoMap, firestore.SetOptions(merge: true));
//   }

//   Future<firestore.QuerySnapshot> getUserByEmail(String email) async {
//     return await _firestore
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();
//   }

//   Future<void> addPost(Map<String, dynamic> postInfoMap) async {
//     await _realtimeDbRef.child('Posts').push().set(postInfoMap);
//   }

//   realtime.Query getPostsQuery() {
//     return _realtimeDbRef.child('Posts').orderByChild('timestamp');
//   }
// }

//----------------new database-------------------------------------------

// import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
// import 'package:firebase_database/firebase_database.dart' as realtime;

// class DatabaseMethods {
//   final firestore.FirebaseFirestore _firestore =
//       firestore.FirebaseFirestore.instance;
//   final realtime.DatabaseReference _realtimeDbRef =
//       realtime.FirebaseDatabase.instance.ref();

//   Future<void> addUserDetails(
//     String userId,
//     Map<String, dynamic> userInfoMap,
//   ) async {
//     await _firestore
//         .collection('users')
//         .doc(userId)
//         .set(userInfoMap, firestore.SetOptions(merge: true));
//   }

//   Future<firestore.QuerySnapshot> getUserByEmail(String email) async {
//     return await _firestore
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();
//   }

//   Future<void> addPost(Map<String, dynamic> postInfoMap) async {
//     await _realtimeDbRef.child('Posts').push().set(postInfoMap);
//   }

//   realtime.Query getPostsQuery() {
//     return _realtimeDbRef.child('Posts').orderByChild('timestamp');
//   }
// }

//------------------------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_database/firebase_database.dart' as realtime;

class DatabaseMethods {
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  final realtime.DatabaseReference _realtimeDbRef =
      realtime.FirebaseDatabase.instance.ref();

  // Add or update user details in Firestore
  Future<void> addUserDetails(
    String userId,
    Map<String, dynamic> userInfoMap,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .set(userInfoMap, firestore.SetOptions(merge: true));
  }

  // Get user by email (from Firestore)
  Future<firestore.QuerySnapshot> getUserByEmail(String email) async {
    return await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  // Get user details by userId
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  // Add post to Realtime Database
  Future<void> addPost(Map<String, dynamic> postInfoMap) async {
    await _realtimeDbRef.child('Posts').push().set(postInfoMap);
  }

  // Get posts ordered by timestamp
  realtime.Query getPostsQuery() {
    return _realtimeDbRef.child('Posts').orderByChild('timestamp');
  }

  // Add comment to a specific post
  Future<void> addComment({
    required String postId,
    required String userId,
    required String commentText,
    required String userName,
    required String userImage,
  }) async {
    final newCommentRef = _realtimeDbRef.child('Comments').child(postId).push();

    final commentData = {
      'text': commentText.trim(),
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    await newCommentRef.set(commentData);
  }

  // Get comments for a specific post
  realtime.Query getCommentsForPost(String postId) {
    return _realtimeDbRef
        .child('Comments')
        .child(postId)
        .orderByChild('timestamp');
  }
}
