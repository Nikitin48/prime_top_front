import 'package:flutter/material.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    super.key,
    required this.child,
    this.padding,
    this.appBarHeight,
  });

  final Widget child;

  final EdgeInsets? padding;

  final double? appBarHeight;

  static const double _defaultAppBarHeight = 96.0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBar = appBarHeight ?? _defaultAppBarHeight;
    
    final minHeight = screenHeight - appBar - statusBarHeight;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: padding != null
            ? Padding(
                padding: padding!,
                child: child,
              )
            : child,
      ),
    );
  }
}
