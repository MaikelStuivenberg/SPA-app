import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  String? _feedbackMessage;
  Color? _feedbackColor;

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.resetPasswordTitle,
      BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthStateLoading) {
            setState(() {
              _loading = true;
              _feedbackMessage = null;
            });
          } else if (state is AuthStateError) {
            setState(() {
              _loading = false;
              _feedbackMessage = AppLocalizations.of(context)!
                  .resetPasswordFailed(state.errorMessage);
              _feedbackColor = Colors.red;
            });
          } else if (state is AuthStateInitial) {
            setState(() {
              _loading = false;
              _feedbackMessage =
                  AppLocalizations.of(context)!.resetPasswordSuccess;
              _feedbackColor = Colors.green;
            });
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.resetPasswordInstruction,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.loginEmailHint,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .loginEmailRequired;
                          }
                          if (!RegExp(
                            r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
                          ).hasMatch(value)) {
                            return AppLocalizations.of(context)!
                                .loginEmailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (_feedbackMessage != null)
                        Text(
                          _feedbackMessage!,
                          style: TextStyle(color: _feedbackColor),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .sendPasswordResetEmail(
                                      _emailController.text,
                                    );
                                  }
                                },
                          child: _loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(AppLocalizations.of(context)!
                                  .resetPasswordSendButton),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _loading
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        icon: const Icon(Icons.arrow_back),
                        label: Text(AppLocalizations.of(context)!
                            .resetPasswordBackToLogin),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      showMenu: false,
      back: true,
    );
  }
}
