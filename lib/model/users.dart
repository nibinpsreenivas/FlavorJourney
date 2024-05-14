import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String phototUrl;
  final String username;
  final String bio;
  final String admin;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.phototUrl,
    required this.username,
    required this.bio,
    required this.admin,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'uid': uid,
        'photoUrl': phototUrl,
        'bio': bio,
        'admin': admin,
        'followers': followers,
        'following': following
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      phototUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      admin: snapshot['admin'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
