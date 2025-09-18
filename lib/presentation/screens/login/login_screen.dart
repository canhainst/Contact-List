import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/theme/app_text_styles.dart';
import 'package:contact_list/logic/auth/auth_bloc.dart';
import 'package:contact_list/logic/auth/auth_event.dart';
import 'package:contact_list/logic/auth/auth_state.dart';
import 'package:contact_list/presentation/widgets/app_button.dart';
import 'package:contact_list/presentation/widgets/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),

              // Logo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Some logo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Username
              AppTextInput(
                label: localizations.translate('login_screen.username'),
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Password
              AppTextInput(
                label: localizations.translate('login_screen.pwd'),
                controller: _passwordController,
                obscureText: true,
              ),

              const SizedBox(height: 24),

              // Sign In button
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    Navigator.pushReplacementNamed(context, "/main");
                  } else if (state is Unauthenticated &&
                      state.message != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message!)));
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return AppButton(
                    text: localizations.translate('login_screen.sign_in'),
                    borderRadius: 30,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginRequested(
                          _usernameController.text.trim(),
                          _passwordController.text.trim(),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  localizations.translate('login_screen.forget_pwd'),
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: localizations.translate('login_screen.sign_up'),
              borderRadius: 30,
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              border: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 0.7,
              ),
              onPressed: () {},
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_outlined, size: 20, color: Colors.grey[600]),

                const SizedBox(width: 4),

                Text(
                  localizations.translate('Contact List'),
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
