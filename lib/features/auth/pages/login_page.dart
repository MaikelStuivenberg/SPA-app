import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      null,
      Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: CircleAvatar(
              radius: 40,
              // When theme is dark, use white background, otherwise use black
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
              child: const FaIcon(FontAwesomeIcons.masksTheater, size: 40),
            ),
          ),
          Positioned(
            top: 85,
            left: 25,
            child: CircleAvatar(
                radius: 60,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
                child: const FaIcon(FontAwesomeIcons.music, size: 60)),
          ),
          Positioned(
            top: 170,
            left: 125,
            child: CircleAvatar(
                radius: 75,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.25),
                child: const FaIcon(FontAwesomeIcons.handsPraying, size: 75)),
          ),
          Positioned(
            top: 230,
            left: 280,
            child: CircleAvatar(
                radius: 90,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.50),
                child: const FaIcon(FontAwesomeIcons.campground, size: 90)),
          ),
          // Positioned(
          //   top: 250,
          //   right: 150,
          //   child: CircleAvatar(
          //     radius: 80,
          //     backgroundColor: AppColors.secondaryColor.shade100,
          //   ),
          // ),
          // Positioned(
          //   top: 150,
          //   right: 50,
          //   child: CircleAvatar(
          //     radius: 80,
          //     backgroundColor: AppColors.secondaryColor.shade100,
          //   ),
          // ),
          // Positioned(
          //   bottom: 10,
          //   left: 10,
          //   child: CircleAvatar(
          //     radius: 80,
          //     backgroundColor: AppColors.mainColor.shade300,
          //   ),
          // ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                  ),
                  Text(
                    'School of Performing Arts',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                  ),
                  const Spacer(),
                  _loginWidget(),
                  const SizedBox(height: 16),
                  _socialWidget(),
                  const SizedBox(height: 16),
                  _signupWidget(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
      showMenu: false,
    );
  }

  Widget _socialWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Or login with',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: IconButton(
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
                icon: Icon(
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
            ),
            const SizedBox(width: 16),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: IconButton(
                onPressed: () async {
                  try {
                    final appleProvider = AppleAuthProvider();
                    await FirebaseAuth.instance
                        .signInWithProvider(appleProvider)
                        .then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.program,
                        (route) => false,
                      );
                    });
                  } on Exception catch (e) {
                    print('exception->$e');
                  }
                },
                icon: Icon(
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
        Text(
          "Don't have an account?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.register);
          },
          child: const Text(
            'Register',
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
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Email address',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.username],
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
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Password',
              prefixIcon: Icon(Icons.password),
            ),
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.password],
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
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
              ),
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
