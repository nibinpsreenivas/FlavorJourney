import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String description;
  final String recipe;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final String cuisine;

  Posts({
    required this.description,
    required this.recipe,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.cuisine,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'recipe': recipe,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
        'cuisine':cuisine,
      };

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
      description: snapshot['description'],
      recipe: snapshot['recipe'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      cuisine: snapshot['cuisine'],
    );
  }
}
