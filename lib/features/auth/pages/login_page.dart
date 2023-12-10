import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      'Hello!',
      SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loginWidget(),
              const SizedBox(height: 16),
              _socialWidget(),
              const SizedBox(height: 16),
              _signupWidget(),
            ],
          ),
        ),
      ),
      showMenu: false,
    );
  }

  Widget _socialWidget() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: Color.fromARGB(64, 255, 255, 255),
                thickness: 1,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Or login with',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Divider(
                color: Color.fromARGB(64, 255, 255, 255),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     FontAwesomeIcons.facebook,
            //     color: AppColors.mainColor,
            //     size: 40,
            //   ),
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(Colors.white),
            //     shape: MaterialStateProperty.all(
            //       RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 16),
            IconButton(
              padding: const EdgeInsets.all(11),
              onPressed: () {
                try {
                  GoogleSignIn().signIn().then((googleUser) async {
                    final googleAuth = await googleUser?.authentication;

                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth?.accessToken,
                      idToken: googleAuth?.idToken,
                    );

                    await FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.program,
                        (route) => false,
                      );
                    });
                  });
                } on Exception catch (e) {
                  print('exception->$e');
                }
              },
              icon: const Icon(
                FontAwesomeIcons.google,
                color: AppColors.mainColor,
                size: 34,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () async {
                final appleProvider = AppleAuthProvider();
                await FirebaseAuth.instance.signInWithProvider(appleProvider);
              },
              icon: const Icon(
                FontAwesomeIcons.apple,
                color: AppColors.mainColor,
                size: 40,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _signupWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.register);
          },
          child: const Text(
            'Register',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Email address',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                // return AppLocalizations.of(context).emailRequired;
                return 'Email is required';
              }

              // Use regex to validate email
              if (!RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                  .hasMatch(value)) {
                // return AppLocalizations.of(context).emailInvalid;
                return 'Email is invalid';
              }

              return null;
            },
            onChanged: (_) => {setState(() {})},
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              focusColor: AppColors.mainColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Password',
              prefixIcon: Icon(Icons.password),
            ),
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value!.isEmpty) {
                // return AppLocalizations.of(context).passwordRequired;
                return 'Password is required';
              }

              return null;
            },
            onChanged: (_) => {setState(() {})},
          ),
          // const SizedBox(height: 0),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton(
          //     onPressed: () {},
          //     child: const Text(
          //       // AppLocalizations.of(context).forgotPassword,
          //       'Forgot password?',
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w300,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ||
                      _formKey.currentState == null ||
                      !_formKey.currentState!.validate()
                  ? null
                  : () {
                      setState(() {
                        _loading = true;
                      });
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )
                          .then(
                        (value) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.program,
                            (route) => false,
                          );

                          setState(() {
                            _loading = false;
                          });
                        },
                      ).catchError((_) {
                        setState(() {
                          _loading = false;
                        });
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.disabledButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
              ),
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
