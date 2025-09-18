import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return DateFormat('HH:mm').format(dateTime);
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return DateFormat('d MMM yyyy').format(dateTime);
  }
}

String formatDuration(Duration duration) {
  if (duration.inHours > 0) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes.remainder(
      60,
    )).toString().padLeft(2, '0');
    return '$hours:$minutes';
  } else {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds.remainder(
      60,
    )).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
