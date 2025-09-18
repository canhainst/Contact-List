import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/theme/app_colors.dart';
import 'package:contact_list/presentation/screens/calls/calls_screen.dart';
import 'package:contact_list/presentation/screens/message/chats_screen.dart';
import 'package:contact_list/presentation/screens/contact/contacts_screen.dart';
import 'package:contact_list/presentation/screens/setting/settings_screen.dart';
import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String labelKey;
  final Widget screen;

  const NavigationItem({
    required this.icon,
    required this.labelKey,
    required this.screen,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.account_circle,
      labelKey: "nav_bar.contacts",
      screen: ContactsScreen(),
    ),
    NavigationItem(
      icon: Icons.call,
      labelKey: "nav_bar.calls",
      screen: CallsScreen(),
    ),
    NavigationItem(
      icon: Icons.chat_bubble_outline,
      labelKey: "nav_bar.chats",
      screen: ChatsScreen(),
    ),
    NavigationItem(
      icon: Icons.settings,
      labelKey: "nav_bar.settings",
      screen: SettingsScreen(),
    ),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: _navigationItems[_selectedIndex].screen,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == _selectedIndex;
              final color = isSelected
                  ? AppColors.primary
                  : colorScheme.onSurface;

              return Expanded(
                child: InkWell(
                  onTap: () => _onNavTap(index),
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.grey.withOpacity(0.2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Container(
                          color: AppColors.primary,
                          width: 72,
                          height: 3,
                        ),

                      const SizedBox(height: 4),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.icon, color: color, size: 28),
                          const SizedBox(height: 4),
                          Text(
                            localizations.translate(item.labelKey),
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
