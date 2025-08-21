import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackRedirectWrapper extends StatelessWidget {
  final Widget child;
  final String targetRoute;

  const BackRedirectWrapper({
    super.key,
    required this.child,
    required this.targetRoute,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context.go(targetRoute);
        return false; // prevent default back
      },
      child: child,
    );
  }
}
