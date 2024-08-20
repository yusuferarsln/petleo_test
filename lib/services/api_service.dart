import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

ApiService get api => ApiService.instance;

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  Future<void> postImage(XFile? pickedFile, String text) async {
    if (pickedFile != null) {
      User? user = FirebaseAuth.instance.currentUser;
      File imageFile = File(pickedFile.path);

      String fileName =
          'users/${user!.uid}/images/${DateTime.now().millisecondsSinceEpoch}.png';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String imagePath = await snapshot.ref.getDownloadURL();

      CollectionReference liveCollection =
          FirebaseFirestore.instance.collection('live');

      DocumentReference newPostRef = liveCollection.doc();
      String postId = newPostRef.id;

      await newPostRef.set({
        'postId': postId,
        'imagePath': imagePath,
        'likes': 0,
        'description': text,
        'userId': user.uid,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getAllPostsWithUsernames() async {
    QuerySnapshot postSnapshot =
        await FirebaseFirestore.instance.collection('live').get();

    List<Map<String, dynamic>> postsWithUsernames = [];

    for (var postDoc in postSnapshot.docs) {
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      String userId = postData['userId'];

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String username = userDoc.exists
          ? (userDoc.data() as Map<String, dynamic>)['userName']
          : 'Unknown User';

      postData['userName'] = username;
      postsWithUsernames.add(postData);
    }

    return postsWithUsernames;
  }

  Future<void> toggleLike(String postId) async {
    final postRef = FirebaseFirestore.instance.collection('live').doc(postId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) {
        throw Exception("Post does not exist!");
      }

      int currentLikes =
          (postSnapshot.data() as Map<String, dynamic>)['likes'] ?? 0;

      transaction.update(postRef, {
        'likes': currentLikes + 1,
      });
    });
  }

  Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('live')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> userPosts = [];

    for (var postDoc in postSnapshot.docs) {
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      postData['postId'] = postDoc.id;

      userPosts.add(postData);
    }

    return userPosts;
  }

  Future<String> getUserDetail(String userId) async {
    print(userId);
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    print(userDoc.data());
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      print(userData);
      return userData['userName'] ?? 'Anonymous';
    } else {
      return 'Unknown User';
    }
  }
}
