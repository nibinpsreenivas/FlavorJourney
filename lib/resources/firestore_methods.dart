import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:FlavorJourney/model/posts.dart';
import 'package:FlavorJourney/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:FlavorJourney/resources/foodrep.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //uploadPost
  Future<String> uploadPost(
    String description,
    String recipe,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    String cuisine,
  ) async {
    String res = 'some error occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Posts post = Posts(
        description: description,
        recipe: recipe,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        cuisine: cuisine,
      );

      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String username, String profilePic) async {
    String res = "some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'postId': postId,
          'commentText': text,
          'uid': uid,
          'username': username,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = "success";
      } else {
        res = "Please write something first...";
      }
    } catch (e) {
      print(e.toString());
    }

    return res;
  }

  //Deleting Post
  Future<String> deletePost(String username, String postId) async {
    String res = 'some error occurred';
    if (username == usersname.users_name) {
      try {
        await _firestore.collection("posts").doc(postId).delete();
        res = 'success';
      } catch (e) {
        print(e.toString());
      }
    } else {
      Fluttertoast.showToast(
        msg: "You are not the owner of the post",
      );
    }

    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
