import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
      'Create an account',
      SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _signupFormWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      showMenu: false,
    );
  }

  Widget _signupFormWidget() {
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
            autofillHints: const [AutofillHints.newUsername],
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
            autofillHints: const [AutofillHints.newPassword],
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              if (value!.isEmpty) {
                // return AppLocalizations.of(context).passwordRequired;
                return 'Password is required';
              }

              if (value.length < 4) {
                // return AppLocalizations.of(context).passwordMinLength;
                return 'Password must be at least 4 characters';
              }

              return null;
            },
            onChanged: (_) => {setState(() {})},
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Password confirmation',
              prefixIcon: Icon(Icons.password),
            ),
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) {
              if (value!.isEmpty) {
                // return AppLocalizations.of(context).passwordRequired;
                return 'Password is required';
              }

              // Check if password confirm is the same as first password field
              if (value != _passwordController.value.text) {
                // return AppLocalizations.of(context).passwordMinLength;
                return 'Password confirmation must be the same as password';
              }

              return null;
            },
            onChanged: (_) => {setState(() {})},
          ),
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
                          .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )
                          .then((value) {
                        setState(() {
                          _loading = false;
                        });
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            )
                            .then(
                              (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.editUser,
                                (route) => false,
                              ),
                            );
                      }).catchError((_) {
                        setState(() {
                          _loading = false;
                        });
                      });
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}
