import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/extensions/content_extension.dart';
import 'package:petleo_test/pages/home_page.dart';
import 'package:petleo_test/pages/sign_in_page.dart';
import 'package:petleo_test/providers/firebase_provider.dart';
import 'package:petleo_test/states/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(firebaseProvider, (previous, next) async {
      if (previous is! Checked && next is Checked) {
        final result = next.value;

        result == true
            ? Timer(const Duration(seconds: 3),
                () => context.replace(const HomePage()))
            : Timer(const Duration(seconds: 3),
                () => context.replace(const SignInPage()));
      }
    });
    return Material(
        color: AppColors.black,
        child: Center(
          child: FadeTransition(
            opacity: _controller,
            child: Center(
              child: SizedBox(
                  child: Text(
                'Petleo',
                style: TextStyle(color: Colors.white, fontSize: 60),
              )),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
