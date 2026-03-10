import 'package:flutter/material.dart';

import '../helpers/app_analytics.dart';

class TrackedScreen extends StatefulWidget {
  const TrackedScreen({
    super.key,
    required this.screenName,
    required this.child,
  });

  final String screenName;
  final Widget child;

  @override
  State<TrackedScreen> createState() => _TrackedScreenState();
}

class _TrackedScreenState extends State<TrackedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppAnalytics.instance.trackScreen(widget.screenName);
    });
  }

  @override
  void didUpdateWidget(covariant TrackedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screenName != widget.screenName) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppAnalytics.instance.trackScreen(widget.screenName);
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
