import 'dart:async';
import 'package:dunno/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GiftLoadingIndicator extends StatefulWidget {
  final List<String> messages;
  final Duration interval;

  const GiftLoadingIndicator({super.key, required this.messages, this.interval = const Duration(seconds: 2)});

  @override
  State<GiftLoadingIndicator> createState() => _GiftLoadingIndicatorState();
}

class _GiftLoadingIndicatorState extends State<GiftLoadingIndicator> {
  late Timer _timer;
  int _idx = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted) return;
      setState(() => _idx = (_idx + 1) % widget.messages.length);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.messages[_idx];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/birthday_gifts.json', width: 300, height: 300, fit: BoxFit.contain, repeat: true),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          transitionBuilder: (child, animation) {
            final slideIn = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            final fadeIn = CurvedAnimation(parent: animation, curve: Curves.easeOut);

            return SlideTransition(
              position: slideIn,
              child: FadeTransition(opacity: fadeIn, child: child),
            );
          },
          child: Text(
            message,
            key: ValueKey(message),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.cerise),
          ),
        ),
      ],
    );
  }
}
