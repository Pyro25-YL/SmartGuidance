import 'package:flutter/material.dart';

class SimpleHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SimpleHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFFB39DDB),
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Search bar
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF757DE8),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Search...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8BBD0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
