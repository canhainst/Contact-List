import 'package:contact_list/core/config/languages.dart';
import 'package:flutter/widgets.dart';

String formatLastSeen(BuildContext context, DateTime lastSeen) {
  final now = DateTime.now();
  final difference = now.difference(lastSeen);

  var localizations = AppLocalizations.of(context)!;

  if (difference.inMinutes == 0) {
    return localizations.translate("contact_screen._formatLastSeen.online");
  } else if (difference.inMinutes < 60) {
    return localizations.translate(
      "contact_screen._formatLastSeen.last_seen_minutes",
      args: {"m": difference.inMinutes.toString()},
    );
  } else if (difference.inHours < 24) {
    return localizations.translate(
      "contact_screen._formatLastSeen.last_seen_hours",
      args: {"h": difference.inHours.toString()},
    );
  } else if (difference.inDays == 1) {
    final time =
        "${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')}";
    return localizations.translate(
      "contact_screen._formatLastSeen.last_seen_yesterday",
      args: {"time": time},
    );
  } else {
    final date =
        "${lastSeen.day.toString().padLeft(2, '0')}/"
        "${lastSeen.month.toString().padLeft(2, '0')}/"
        "${lastSeen.year.toString().substring(2)}";
    return localizations.translate(
      "contact_screen._formatLastSeen.last_seen_date",
      args: {"date": date},
    );
  }
}
