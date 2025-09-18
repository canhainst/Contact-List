import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String avatarUrl =
      'https://jbagy.me/wp-content/uploads/2025/03/anh-avatar-vo-tri-meo-1.jpg';

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.qr_code, size: 24),
                ),

                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                      SizedBox(height: 4),
                      Text('Nguyễn Thành'),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('+84 397 300 280', style: AppTextStyles.subbody),
                          SizedBox(width: 8),
                          Icon(Icons.fiber_manual_record, size: 7),
                          SizedBox(width: 8),
                          Text('@Bane_Scott', style: AppTextStyles.subbody),
                        ],
                      ),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    localizations.translate('messages_screen.edit'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
