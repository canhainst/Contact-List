import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/theme/app_text_styles.dart';
import 'package:contact_list/core/utils/format_string.dart';
import 'package:contact_list/core/utils/url_launcher.dart';
import 'package:contact_list/data/models/contact_model.dart';
import 'package:flutter/material.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late bool isMuted;

  @override
  void initState() {
    super.initState();
    isMuted = widget.contact.isMuted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Colors.blueGrey,
            ),

            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                      Text(
                        localizations.translate('common.back'),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.contact.avatarUrl != null
                      ? NetworkImage(widget.contact.avatarUrl!)
                      : null,
                  child: widget.contact.avatarUrl == null
                      ? Text(
                          widget.contact.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50 / 2,
                          ),
                        )
                      : null,
                ),
                SizedBox(height: 8),

                Text(
                  widget.contact.name,
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                ),

                Text(
                  formatLastSeen(context, widget.contact.lastSeen),
                  style: AppTextStyles.subbody.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectionBlock(
                          _iconSelection(context, Icons.message, 'message'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildSelectionBlock(
                          _iconSelection(context, Icons.call, 'call'),
                          onPressed: () {
                            callPhone(widget.contact.phone);
                          },
                        ),
                      ),
                      SizedBox(width: 8),

                      Expanded(
                        child: _buildSelectionBlock(
                          _iconSelection(
                            context,
                            isMuted
                                ? Icons.notifications_off
                                : Icons.notifications,
                            isMuted ? 'unmute' : 'mute',
                          ),
                          onPressed: () {
                            setState(() {
                              isMuted = !isMuted;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),

                      Expanded(
                        child: _buildSelectionBlock(
                          _iconSelection(context, Icons.more_horiz, 'more'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  _buildSelectionBlock(
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "9 Nov 2022",
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "16:02",
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                localizations.translate(
                                  'contact_screen.detail.missed_call',
                                ),
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  _buildSelectionBlock(
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localizations.translate(
                              'contact_screen.detail.contact_add',
                            ),
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 0.5),
                          Text(
                            localizations.translate(
                              'contact_screen.detail.block',
                            ),
                            style: AppTextStyles.body.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconSelection(BuildContext context, IconData icon, String key) {
    final theme = Theme.of(context);
    var localizations = AppLocalizations.of(context)!;
    Color color = theme.iconTheme.color!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Text(
          localizations.translate('contact_screen.detail.$key'),
          style: AppTextStyles.subbody.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildSelectionBlock(Widget child, {VoidCallback? onPressed}) {
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
