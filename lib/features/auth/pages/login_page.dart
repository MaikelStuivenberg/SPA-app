import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/app/injection/injection.dart';
import 'package:spa_app/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/features/auth/pages/password_reset_page.dart';

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
  bool _showWrongCredentials = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      null,
      BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthStateLoading) {
            setState(() {
              _loading = true;
            });
          } else if (state is AuthStateError) {
            setState(() {
              print(state.errorMessage);
              _loading = false;
              _showWrongCredentials = true;
            });
          } else if (state is AuthStateSuccess) {
            _loading = false;
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home,
              (route) => false,
            );
          }
        },
        child: Stack(
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
                child: const FaIcon(FontAwesomeIcons.music, size: 60),
              ),
            ),
            Positioned(
              top: 170,
              left: 125,
              child: CircleAvatar(
                radius: 75,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.25),
                child: const FaIcon(FontAwesomeIcons.handsPraying, size: 75),
              ),
            ),
            Positioned(
              top: 230,
              left: 280,
              child: CircleAvatar(
                radius: 90,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.50),
                child: const FaIcon(FontAwesomeIcons.campground, size: 90),
              ),
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.loginWelcome,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.loginWelcomeSPA,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 16),
                    _loginWidget(),
                    const SizedBox(height: 16),
                    _socialWidget(),
                    const SizedBox(height: 16),
                    _signupWidget(),
                    const Spacer(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            Text(AppLocalizations.of(context)!.loginSocial),
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
                  BlocProvider.of<AuthCubit>(context).loginGoogle();
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
            ),
            const SizedBox(width: 16),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: IconButton(
                onPressed: () async {
                  await BlocProvider.of<AuthCubit>(context).loginApple();
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
          AppLocalizations.of(context)!.loginNoAccount,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.register);
          },
          child: Text(
            AppLocalizations.of(context)!.loginRegister,
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
            decoration: InputDecoration(
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: AppLocalizations.of(context)!.loginEmailHint,
              prefixIcon: const Icon(Icons.alternate_email),
            ),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.username],
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context)!.loginEmailRequired;
              }
              if (!RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                  .hasMatch(value)) {
                return AppLocalizations.of(context)!.loginEmailInvalid;
              }
              return null;
            },
            onChanged: (_) => {setState(() {})},
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: AppLocalizations.of(context)!.loginPasswordHint,
              prefixIcon: const Icon(Icons.password),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.password],
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context)!.loginPasswordRequired;
              }
              return null;
            },
            onChanged: (_) => {setState(() {})},
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.resetPassword);
              },
              child: Text(
                AppLocalizations.of(context)!.loginForgotPassword,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          if (_showWrongCredentials)
            Text(
              AppLocalizations.of(context)!.loginWrongCredentials,
              style: const TextStyle(
                color: Colors.red,
              ),
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
                      BlocProvider.of<AuthCubit>(context).loginUsernamePassword(
                        _emailController.text,
                        _passwordController.text,
                      );
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
                  : Text(AppLocalizations.of(context)!.loginButton),
            ),
          ),
        ],
      ),
    );
  }
}
