import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:FlavorJourney/screens/imagesearch.dart';
import 'package:FlavorJourney/screens/predic_post.dart';
import 'package:FlavorJourney/screens/profile_screen.dart';

import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  SearchScreen(),
  postmlPage(),
  imagesearch(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
