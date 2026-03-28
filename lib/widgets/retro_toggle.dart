import 'package:flutter/material.dart';

class RetroToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RetroToggle({super.key, required this.value, required this.onChanged});

  @override
  State<RetroToggle> createState() => _RetroToggleState();
}

class _RetroToggleState extends State<RetroToggle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    if (widget.value) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(RetroToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
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
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 90,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF111111), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(20),
                  offset: const Offset(1, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Track Inset Simulation
                Center(
                  child: Container(
                    width: 78,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151515),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                // Red Status Light (Recessed)
                Positioned(
                  left: 18,
                  top: 14,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.value ? const Color(0xFFFF2222) : const Color(0xFF441111),
                      boxShadow: widget.value ? [
                        BoxShadow(
                          color: const Color(0xFFFF2222).withAlpha(180),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ] : [],
                    ),
                  ),
                ),
                // Sliding Handle
                Positioned(
                  left: 6 + (_animation.value * 38),
                  top: 6,
                  child: Container(
                    width: 40,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF666666), Color(0xFF333333)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(150),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) => Container(
                          width: 2.5,
                          height: 16,
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(80),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        )),
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
