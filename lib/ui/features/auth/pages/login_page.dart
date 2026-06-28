import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/post_auth_destination.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/core/widgets/default_body.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/auth/widgets/auth_decorative_background.dart';

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
              _loading = false;
              _showWrongCredentials = true;
            });
          } else if (state is AuthStateSuccess) {
            _loading = false;
            context.go(postAuthDestination(state));
          }
        },
        child: Stack(
          children: [
            const AuthDecorativeBackground(),
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
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: Theme.of(context).colorScheme.primary,
                  size: 34,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.surface,
                  ),
                  shape: WidgetStateProperty.all(
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
                icon: Icon(
                  FontAwesomeIcons.apple,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.surface,
                  ),
                  shape: WidgetStateProperty.all(
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
            context.push(RoutePaths.register);
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
            onChanged: (_) => setState(() {}),
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
            onChanged: (_) => setState(() {}),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                context.push(RoutePaths.resetPassword);
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
              style: TextStyle(
                color: context.appColors.error,
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
