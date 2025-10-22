import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyLinkButton extends StatefulWidget {
  const CopyLinkButton({super.key, required this.link, this.iconSize = 20});

  final Uri link;
  final double iconSize;

  @override
  State<CopyLinkButton> createState() => _CopyLinkButtonState();
}

class _CopyLinkButtonState extends State<CopyLinkButton> {
  bool _copied = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: widget.link.toString()));
    HapticFeedback.selectionClick();

    if (!mounted) return;
    setState(() => _copied = true);
    debugPrint('Copied: ${widget.link}');

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Link copied', textAlign: TextAlign.center),
        ),
      );

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return IconButton(
      tooltip: _copied ? 'Copied!' : 'Copy link',
      onPressed: () => _copy(context),
      iconSize: widget.iconSize,
      color: _copied ? Colors.green : primary,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (c, anim) => ScaleTransition(scale: anim, child: c),
        child: _copied
            ? const Icon(Icons.check_rounded, key: ValueKey('ok'))
            : const Icon(Icons.copy_rounded, key: ValueKey('copy')),
      ),
    );
  }
}
