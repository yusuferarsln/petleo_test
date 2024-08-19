import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petleo_test/constants/app_colors.dart';
import 'package:petleo_test/extensions/content_extension.dart';
import 'package:petleo_test/firebase/firebase_authentication.dart';
import 'package:petleo_test/pages/home_page.dart';
import 'package:petleo_test/pages/sign_up_page.dart';
import 'package:petleo_test/widgets/widget.dart';
import 'package:string_validator/string_validator.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitted = false;
  bool isLoading = false;

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
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Petleo',
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ))
          ],
        ),
      ),
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
                  const Text(
                    'Welcome Petleo',
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Sign in and begin the explore',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.softWhite,
                        fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Email',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    style: const TextStyle(color: AppColors.white),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: AppColors.white)),
                    onChanged: _submitted
                        ? (value) => _formKey.currentState!.validate()
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is empty';
                      } else if (!isEmail(value)) {
                        return 'Email is not valid';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.white)),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = !isLoading;
                        _submitted = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        var value = await auth.authLogin(
                            _emailController.text, _passwordController.text);
                        switch (value) {
                          case 0:
                            context.replace(const HomePage());
                            break;
                          case 3:
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Credentails are wrong')));
                            break;

                          default:
                        }
                      }

                      setState(() {
                        isLoading = !isLoading;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      backgroundColor: AppColors.cadetGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // adjust the radius as required
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.green,
                            )
                          : const Text('Sign-In'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          context.go(const SignUpPage());
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Dont you have an account?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: AppColors.cadetGreen,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
