import 'package:flutter/material.dart';
import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/extensions/content_extension.dart';
import 'package:petleo_test/firebase/firebase_authentication.dart';
import 'package:petleo_test/pages/create_post_page.dart';
import 'package:petleo_test/pages/live_section.dart';
import 'package:petleo_test/pages/profile_page.dart';
import 'package:petleo_test/pages/sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    const LiveSection(),
    const CreatePostPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cadetGreen,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.black,
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: _selectedIndex == 0 ? 25 : 20,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.white)),
                  child: Icon(
                    color: Colors.white,
                    Icons.add,
                    size: _selectedIndex == 1 ? 25 : 20,
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  color: Colors.white,
                  Icons.person,
                  size: _selectedIndex == 2 ? 25 : 20,
                ),
                label: '')
          ]),
    );
  }
}
