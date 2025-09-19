import 'package:contact_list/core/config/language_cubit.dart';
import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/logic/auth/auth_bloc.dart';
import 'package:contact_list/logic/auth/auth_event.dart';
import 'package:contact_list/presentation/widgets/app_button.dart';
import 'package:contact_list/core/theme/app_theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String avatarUrl =
      'https://jbagy.me/wp-content/uploads/2025/03/anh-avatar-vo-tri-meo-1.jpg';

  bool pushNotifications = true;
  bool useFingerprint = false;
  ThemeMode _selectedTheme = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var localizations = AppLocalizations.of(context)!;

    // read current theme mode from cubit
    final themeCubit = context.read<ThemeCubit>();
    _selectedTheme = themeCubit.mode;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              expandedHeight: 260,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey.shade600,
                        Colors.blueGrey.shade300,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 48),
                              Text(
                                localizations.translate('nav_bar.settings'),
                                style:
                                    (theme.textTheme.titleLarge ??
                                            theme.textTheme.headlineSmall)
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CircleAvatar(
                            radius: 54,
                            backgroundImage: NetworkImage(avatarUrl),
                            backgroundColor: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Nguyễn Thành',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '+84 397 300 280  •  @Bane_Scott',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Column(
                  children: [
                    _buildInfoTile(
                      Icons.person,
                      localizations.translate('settings_screen.account'),
                      localizations.translate('settings_screen.account_sub'),
                    ),
                    _buildInfoTile(
                      Icons.settings,
                      localizations.translate('settings_screen.general'),
                      localizations.translate('settings_screen.general_sub'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _sectionHeader(
                localizations.translate('settings_screen.preferences'),
              ),

              const SizedBox(height: 6),
              _buildSwitchTile(
                Icons.notifications,
                localizations.translate('settings_screen.push_notifications'),
                pushNotifications,
                onChanged: (v) {
                  setState(() => pushNotifications = v);
                },
              ),

              _buildSwitchTile(
                Icons.dark_mode,
                localizations.translate('settings_screen.dark_mode'),
                _selectedTheme == ThemeMode.dark,
                onChanged: (v) {
                  setState(() {
                    _selectedTheme = v ? ThemeMode.dark : ThemeMode.light;
                  });
                  context.read<ThemeCubit>().setThemeMode(_selectedTheme);
                },
              ),

              _buildSwitchTile(
                Icons.fingerprint,
                localizations.translate('settings_screen.use_fingerprint'),
                useFingerprint,
                onChanged: (v) {
                  setState(() => useFingerprint = v);
                },
              ),
              const SizedBox(height: 12),

              _sectionHeader(
                localizations.translate('settings_screen.language.title'),
              ),

              const SizedBox(height: 6),

              // Language selection (system / en / vi / cn)
              Builder(
                builder: (context) {
                  final langCubit = context.read<LanguageCubit>();
                  final current = langCubit.languageCode;

                  return DropdownButtonFormField<String>(
                    value: current,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'system',
                        child: Row(
                          children: [
                            const Icon(Icons.phone_iphone, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              localizations.translate(
                                'settings_screen.language.lang_system',
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Row(
                          children: [
                            const Icon(Icons.language, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              localizations.translate(
                                'settings_screen.language.lang_en',
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'vi',
                        child: Row(
                          children: [
                            const Icon(Icons.language, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              localizations.translate(
                                'settings_screen.language.lang_vi',
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'zh',
                        child: Row(
                          children: [
                            const Icon(Icons.language, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              localizations.translate(
                                'settings_screen.language.lang_cn',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      context.read<LanguageCubit>().setLanguage(v);
                    },
                  );
                },
              ),

              const SizedBox(height: 12),

              _sectionHeader('Support'),
              const SizedBox(height: 6),
              _buildTile(
                Icons.help_outline,
                localizations.translate('settings_screen.help_feedback'),
                onTap: () {},
              ),
              _buildTile(
                Icons.verified,
                localizations.translate('settings_screen.about'),
                subtitle: 'v1.0.0',
                onTap: () {},
              ),

              const SizedBox(height: 20),
              AppButton(
                text: localizations.translate('settings_screen.logout'),
                color: Colors.redAccent,
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());

                  Navigator.pushReplacementNamed(context, '/');
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value, {
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      activeColor: Colors.blue.shade700,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      secondary: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
