// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/widgets.dart';

// ignore_for_file: unused_element

enum AdaptiveVariant { mobileApp, mobileWeb, desktopApp, desktopWeb }

abstract class AdaptiveBuilds {
  Widget _buildMobileApp(BuildContext context);
  Widget _buildMobileWeb(BuildContext context);
  Widget _buildDesktopApp(BuildContext context);
  Widget _buildDesktopWeb(BuildContext context);
}

mixin AdaptiveBuildsDefault {
  Widget _buildMobileApp(BuildContext context) => SizedBox.shrink();
  Widget _buildMobileWeb(BuildContext context) => SizedBox.shrink();
  Widget _buildDesktopApp(BuildContext context) => SizedBox.shrink();
  Widget _buildDesktopWeb(BuildContext context) => SizedBox.shrink();
}

abstract class AdaptiveStatelessWidget extends StatelessWidget
    implements AdaptiveBuilds {
  const AdaptiveStatelessWidget.mobileApp({super.key})
      : variant = AdaptiveVariant.mobileApp;

  const AdaptiveStatelessWidget.mobileWeb({super.key})
      : variant = AdaptiveVariant.mobileWeb;

  const AdaptiveStatelessWidget.desktopApp({super.key})
      : variant = AdaptiveVariant.desktopApp;

  const AdaptiveStatelessWidget.desktopWeb({super.key})
      : variant = AdaptiveVariant.desktopWeb;

  final AdaptiveVariant variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AdaptiveVariant.mobileApp:
        return _buildMobileApp(context);
      case AdaptiveVariant.mobileWeb:
        return _buildMobileWeb(context);
      case AdaptiveVariant.desktopApp:
        return _buildDesktopApp(context);
      case AdaptiveVariant.desktopWeb:
        return _buildDesktopWeb(context);
    }
  }
}

abstract class AdaptiveStatefulWidget extends StatefulWidget {
  const AdaptiveStatefulWidget.mobileApp({super.key})
      : variant = AdaptiveVariant.mobileApp;

  const AdaptiveStatefulWidget.mobileWeb({super.key})
      : variant = AdaptiveVariant.mobileWeb;

  const AdaptiveStatefulWidget.desktopApp({super.key})
      : variant = AdaptiveVariant.desktopApp;

  const AdaptiveStatefulWidget.desktopWeb({super.key})
      : variant = AdaptiveVariant.desktopWeb;

  final AdaptiveVariant variant;

  @override
  AdaptiveState<AdaptiveStatefulWidget> createState();
}

abstract class AdaptiveState<T extends AdaptiveStatefulWidget> extends State<T>
    with AdaptiveBuilds {
  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case AdaptiveVariant.mobileApp:
        return _buildMobileApp(context);
      case AdaptiveVariant.mobileWeb:
        return _buildMobileWeb(context);
      case AdaptiveVariant.desktopApp:
        return _buildDesktopApp(context);
      case AdaptiveVariant.desktopWeb:
        return _buildDesktopWeb(context);
    }
  }
}

