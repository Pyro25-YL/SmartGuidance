import 'package:flutter/material.dart';

class FeatureItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  FeatureItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}

class FeatureMenuGrid extends StatelessWidget {
  final List<FeatureItem> items;

  const FeatureMenuGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: items
            .map(
              (item) => InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: item.onTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: item.iconColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 32,
                        color: item.iconColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
