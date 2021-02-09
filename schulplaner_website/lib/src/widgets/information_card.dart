import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget actions;

  const InformationCard({
    Key key,
    @required this.title,
    @required this.description,
    this.actions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            if (actions != null) ...[
              actions,
              SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}
