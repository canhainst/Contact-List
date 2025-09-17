import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContactSkeleton extends StatelessWidget {
  const ContactSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.white, radius: 24),
        title: Container(
          height: 14,
          width: double.infinity,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 6),
        ),
        subtitle: Container(height: 12, color: Colors.white),
      ),
    );
  }
}
