import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  final bool status;
  final VoidCallback onRetry;
  const NotFound({super.key, required this.onRetry, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, color: Colors.red, size: 80),
            const SizedBox(height: 16),
            Text('No Internet Connection', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: status
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
