import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

void callPhone(String phoneNumber) async {
  final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(telUri)) {
    await launchUrl(telUri);
  } else {
    log('Cannot launch phone call to $phoneNumber');
  }
}
