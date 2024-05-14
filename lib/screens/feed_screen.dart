import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:FlavorJourney/utils/colors.dart';
import 'package:FlavorJourney/utils/global_variables.dart';
import 'package:FlavorJourney/resources/foodrep.dart';
import 'package:FlavorJourney/utils/utils.dart';
import '../widgets/change_theme_button_widget.dart';
import '../widgets/post_card.dart';
import 'package:FlavorJourney/chatbot/chatmain.dart';

class FeedScreen extends StatefulWidget {
  final String uid;
  const FeedScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var userData = {};
  bool isLoading = false;
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      userData = userSnapshot.data()!;
      usersname.users_name = userData["username"];
      print(usersname.users_name);

      //Get post length

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: width > webScreenSize
          ? webBackgroundColor
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: Color.fromARGB(255, 255, 250, 230),
              centerTitle: false,
              titleSpacing: -10,
              leading: Container(
                height: 200,
                // Optional padding for the image
                child: Image.asset(
                  "assets/hello.png",
                  height: 250, width: 200,
                  // or choose a fit option based on your preference
                ),
              ),
              title: Row(
                children: [
                  Image.asset(
                    "assets/hello1.png",
                    height: 50,
                    // or choose a fit option based on your preference
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.chat,
                      color: Colors.black,
                    ), // Chatbot icon
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                  ),
                ],
              )),
      body: Container(
        color: Color.fromARGB(255, 255, 250, 230),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? width * 0.3 : 0,
                    vertical: width > webScreenSize ? 10 : 0,
                  ),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
