import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FlavorJourney/utils/colors.dart';

import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  //It will make so many calls to Database that's why not useful.
  // String username = "";

  // @override
  // void initState() {
  //   super.initState();
  //   getUsername();
  // }

  // void getUsername() async {
  //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();

  //   setState(() {
  //     username = (snapshot.data() as Map<String, dynamic>)['username'];
  //   });
  // }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Using Provider: It will make just one call to Database that's why useful.
    // userModel.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Color.fromARGB(255, 255, 250, 230),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color:
                  _page == 0 ? Color.fromARGB(255, 255, 95, 0) : secondaryColor,
            ),
            backgroundColor: Color.fromARGB(255, 255, 95, 0),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1
                    ? Color.fromARGB(255, 255, 95, 0)
                    : secondaryColor,
              ),
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2
                    ? Color.fromARGB(255, 255, 95, 0)
                    : secondaryColor,
              ),
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.fastfood,
                color: _page == 3
                    ? Color.fromARGB(255, 255, 95, 0)
                    : secondaryColor,
              ),
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4
                    ? Color.fromARGB(255, 255, 95, 0)
                    : secondaryColor,
              ),
              backgroundColor: Theme.of(context).primaryColor),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
