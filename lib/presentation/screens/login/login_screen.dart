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
  bool _remember = false;

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
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueGrey, Colors.grey],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // Header + animated logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.translate('login_screen.welcome'),
                        style: AppTextStyles.title.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const _LogoGlow(),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Card with inputs
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextInput(
                            label: localizations.translate(
                              'login_screen.username',
                            ),
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 12),

                          AppTextInput(
                            label: localizations.translate('login_screen.pwd'),
                            controller: _passwordController,
                            obscureText: true,
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Switch(
                                value: _remember,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (v) => setState(() => _remember = v),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  localizations.translate(
                                    'login_screen.remember_me',
                                  ),
                                  style: AppTextStyles.body,
                                ),
                              ),

                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  localizations.translate(
                                    'login_screen.forget_pwd',
                                  ),
                                  style: AppTextStyles.body.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Sign In button
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is Authenticated) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/main",
                                );
                              } else if (state is Unauthenticated &&
                                  state.message != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message!)),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return AppButton(
                                text: localizations.translate(
                                  'login_screen.sign_in',
                                ),
                                borderRadius: 12,
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Social / alternative sign in
                  Column(
                    children: [
                      Text(
                        localizations.translate(
                          'login_screen.or_continue_with',
                        ),
                        style: AppTextStyles.subbody.copyWith(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            path:
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/2023_Facebook_icon.svg/667px-2023_Facebook_icon.svg.png',
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12),
                          _SocialButton(
                            path:
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Gmail_icon_%282020%29.svg/1024px-Gmail_icon_%282020%29.svg.png',
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.translate('login_screen.no_account'),
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              localizations.translate('login_screen.sign_up'),
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Small glowing logo widget used in header
class _LogoGlow extends StatelessWidget {
  const _LogoGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [Colors.white70, Colors.white]),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(Icons.contact_phone, color: Colors.blueGrey, size: 28),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String path; // đường dẫn hình ảnh từ network
  final VoidCallback onPressed;

  const _SocialButton({required this.path, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            path,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 24, color: Colors.red);
            },
          ),
        ),
      ),
    );
  }
}
