import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThemeToggle extends StatefulWidget {
  final bool isPixelMode;
  final VoidCallback onToggle;

  const ThemeToggle({super.key, required this.isPixelMode, required this.onToggle});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutExpo);
    if (widget.isPixelMode) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPixelMode != oldWidget.isPixelMode) {
      if (widget.isPixelMode) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 70,
            height: 36,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.blue.withAlpha(50), Colors.black, _animation.value),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Color.lerp(Colors.orange.withAlpha(100), const Color(0xFF00FF88).withAlpha(100), _animation.value)!,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Sliding Icon Container
                Positioned(
                  left: _animation.value * 34,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(Colors.orange, Colors.black, _animation.value),
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(Colors.orange.withAlpha(150), const Color(0xFF00FF88).withAlpha(150), _animation.value)!,
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                      border: _animation.value > 0.5 
                        ? Border.all(color: const Color(0xFF00FF88), width: 1.5)
                        : null,
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: _animation.value * math.pi,
                        child: Icon(
                          _animation.value < 0.5 ? Icons.wb_sunny : Icons.nightlight_round,
                          size: 18,
                          color: _animation.value < 0.5 ? Colors.white : const Color(0xFF00FF88),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
