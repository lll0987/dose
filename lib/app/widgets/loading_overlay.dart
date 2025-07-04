import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withAlpha(55), // MD3 推荐半透明遮罩
            child: Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
