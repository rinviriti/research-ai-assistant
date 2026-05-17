import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 6),

          Text(
            subtitle!,
            style: const TextStyle(color: Colors.white60, height: 1.4),
          ),
        ],
      ],
    );
  }
}
