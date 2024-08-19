import 'package:flutter/material.dart';
import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/extensions/content_extension.dart';
import 'package:petleo_test/firebase/firebase_authentication.dart';
import 'package:petleo_test/pages/sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cadetGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              auth.authSignOut();
              context.replace(SignInPage());
            },
            child: Text('Sign out')),
      ),
    );
  }
}
