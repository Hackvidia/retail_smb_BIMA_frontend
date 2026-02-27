import 'package:flutter/material.dart';

class SignupHeroWidget extends StatelessWidget {
  const SignupHeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: const Alignment(-0.2, 0.32),
              child: Transform.rotate(
                angle: -0.52,
                child: const _PuzzleShape(size: 136),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/sm-icon.png',
                width: 168,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PuzzleShape extends StatelessWidget {
  const _PuzzleShape({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final double nub = size * 0.24;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFB9B9BD)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A7F9BF6),
                  offset: Offset(0, 2),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: _Nub(size: nub),
          ),
          Align(
            alignment: const Alignment(1, 0),
            child: _Nub(size: nub),
          ),
          Align(
            alignment: const Alignment(-1, 0.26),
            child: _Nub(size: nub),
          ),
        ],
      ),
    );
  }
}

class _Nub extends StatelessWidget {
  const _Nub({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB9B9BD)),
      ),
    );
  }
}
