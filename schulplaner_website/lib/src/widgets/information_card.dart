import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget? actions;

  const InformationCard({
    Key? key,
    required this.title,
    required this.description,
    this.actions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            if (actions != null) ...[
              actions!,
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}
