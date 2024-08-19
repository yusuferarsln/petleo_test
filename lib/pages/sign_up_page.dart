import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/extensions/content_extension.dart';
import 'package:petleo_test/firebase/firebase_authentication.dart';
import 'package:petleo_test/pages/home_page.dart';
import 'package:petleo_test/pages/sign_in_page.dart';
import 'package:petleo_test/widgets/widget.dart';
import 'package:string_validator/string_validator.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _submitted = false;
  bool loading = false;
  bool ischecked = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: AppColors.black,
          title: Center(
              child: Text(
            'Petleo',
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ))),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Email',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    style: TextStyle(color: AppColors.white),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    onChanged: _submitted
                        ? (value) => _formKey.currentState!.validate()
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is Empty';
                      } else if (!isEmail(value)) {
                        return 'Enter proper email';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'User Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    style: TextStyle(color: AppColors.white),
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    autofillHints: const [AutofillHints.name],
                    textInputAction: TextInputAction.next,
                    onChanged: _submitted
                        ? (value) => _formKey.currentState!.validate()
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is empty';
                      } else if (_nameController.text.length <= 4) {
                        return 'Username too short';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Password',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  PasswordField(
                      controller: _passwordController,
                      onChanged: _submitted
                          ? (value) => _formKey.currentState!.validate()
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is empty';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) => //signin
                          doNothing()),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          context.go(const SignInPage());
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: AppColors.cadetGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = !loading;
                        _submitted = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        print(_emailController.text);
                        var value = await auth.authRegister(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text);

                        if (value != null) {
                          //set user

                          context.replace(const HomePage());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error')));
                        }
                      }

                      setState(() {
                        loading = !loading;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: AppColors.cadetGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // adjust the radius as required
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: loading
                          ? CircularProgressIndicator(
                              color: AppColors.green,
                            )
                          : Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void doNothing() {}
