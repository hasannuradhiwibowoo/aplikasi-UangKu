import 'dart:async';

import 'package:flutter/material.dart';

class HalamanSplash extends StatefulWidget {
  const HalamanSplash({
    super.key,
    required this.halamanBerikutnya,
  });

  final Widget halamanBerikutnya;

  @override
  State<HalamanSplash> createState() => _HalamanSplashState();
}

class _HalamanSplashState extends State<HalamanSplash> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => widget.halamanBerikutnya,
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF064B38),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LogoUangKu(),
                  SizedBox(height: 17),
                  Text(
                    'UangKu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Atur uangmu, lebih tenang.',
                    style: TextStyle(color: Color(0xFFD6E8E0), fontSize: 11),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 27,
              child: Text(
                'MEMUAT...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB4D2C5),
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoUangKu extends StatelessWidget {
  const _LogoUangKu();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        color: const Color(0xFF07966F),
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.14,
            child: const Icon(Icons.payments_rounded, size: 42, color: Color(0xFFFFD76A)),
          ),
          const Positioned(
            right: 12,
            bottom: 10,
            child: Icon(Icons.account_balance_wallet_rounded, size: 31, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
