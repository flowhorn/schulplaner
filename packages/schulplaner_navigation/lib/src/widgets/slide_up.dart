import 'package:flutter/material.dart';

class SlideUp extends StatefulWidget {
  final Widget child;
  SlideUp({required this.child, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlideUpState();
}

class _SlideUpState extends State<SlideUp> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(controller),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(controller),
        child: widget.child,
      ),
    );
  }
}
