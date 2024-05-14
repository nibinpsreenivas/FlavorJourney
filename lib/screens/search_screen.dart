import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services.dart package
import 'package:FlavorJourney/screens/profile_screen.dart';
import 'package:FlavorJourney/screens/search.dart';
import 'package:FlavorJourney/utils/global_variables.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:FlavorJourney/widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(
                  255, 255, 250, 230), // Set background color to black
              title: Center(
                  child: Text('Search',
                      style: TextStyle(
                          color:
                              Colors.white))), // Set title text color to white
              content: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 24), // Adjust padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search.collection = "users";
                          search.fields = "username";
                        });
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12), // Add padding to each field
                        // color: search.collection == "users" ? Colors.blueGrey : Colors.transparent, // Set background color of field
                        child: Text(
                          "User",
                          style: TextStyle(
                            color: search.collection == "users"
                                ? Colors.blueGrey
                                : Colors
                                    .white, // Set text color based on selection
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Add space between fields
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search.collection = "posts";
                          search.fields = "description";
                        });
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12), // Add padding to each field
                        //color: search.collection == "posts" && search.fields == "description" ? Colors.blueGrey : Colors.transparent, // Set background color of field
                        child: Text(
                          "Food",
                          style: TextStyle(
                            color: search.collection == "posts" &&
                                    search.fields == "description"
                                ? Colors.blueGrey
                                : Colors
                                    .white, // Set text color based on selection
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Add space between fields
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search.collection = "posts";
                          search.fields = "cuisine";
                        });
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12), // Add padding to each field
                        // color: search.collection == "posts" && search.fields == "cuisine" ? Colors.blueGrey : Colors.transparent, // Set background color of field
                        child: Text(
                          "Cuisine",
                          style: TextStyle(
                            color: search.collection == "posts" &&
                                    search.fields == "cuisine"
                                ? Colors.blueGrey
                                : Colors
                                    .white, // Set text color based on selection
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Set the status bar color to match the background color of the app
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Set status bar color
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 250, 230),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 250, 230),
          title: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: _searchController,
            decoration: const InputDecoration(),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: _showAddNoteDialog,
            ),
          ],
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection(search.collection)
                    .where(search.fields, isEqualTo: _searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return search.fields == "username"
                      ? ListView.builder(
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid']),
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['photoUrl']),
                                ),
                                title: Text(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['username'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  width > webScreenSize ? width * 0.3 : 0,
                              vertical: width > webScreenSize ? 10 : 0,
                            ),
                            child: PostCard(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl']),
                    staggeredTileBuilder: (index) =>
                        MediaQuery.of(context).size.width > webScreenSize
                            ? StaggeredTile.count(
                                (index % 7 == 0) ? 1 : 1,
                                (index % 7 == 0) ? 1 : 1,
                              )
                            : StaggeredTile.count(
                                (index % 7 == 0) ? 2 : 1,
                                (index % 7 == 0) ? 2 : 1,
                              ),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 9,
                  );
                },
              ),
      ),
    );
  }
}
