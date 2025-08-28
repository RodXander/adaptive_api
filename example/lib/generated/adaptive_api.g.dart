// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/widgets.dart';

enum AdaptiveVariant { mobileApp, mobileWeb, desktopApp, desktopWeb }

abstract class AdaptiveBuilds {
  Widget buildMobileApp(BuildContext context);
  Widget buildMobileWeb(BuildContext context);
  Widget buildDesktopApp(BuildContext context);
  Widget buildDesktopWeb(BuildContext context);
}

mixin AdaptiveBuildsDefault {
  Widget buildMobileApp(BuildContext context) => const SizedBox.shrink();
  Widget buildMobileWeb(BuildContext context) => const SizedBox.shrink();
  Widget buildDesktopApp(BuildContext context) => const SizedBox.shrink();
  Widget buildDesktopWeb(BuildContext context) => const SizedBox.shrink();
}

abstract class AdaptiveStatelessWidget extends StatelessWidget
    implements AdaptiveBuilds {
  const AdaptiveStatelessWidget({super.key, required this.variant});

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
        return buildMobileApp(context);
      case AdaptiveVariant.mobileWeb:
        return buildMobileWeb(context);
      case AdaptiveVariant.desktopApp:
        return buildDesktopApp(context);
      case AdaptiveVariant.desktopWeb:
        return buildDesktopWeb(context);
    }
  }
}

abstract class AdaptiveStatefulWidget extends StatefulWidget {
  const AdaptiveStatefulWidget({super.key, required this.variant});

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
    implements AdaptiveBuilds {
  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case AdaptiveVariant.mobileApp:
        return buildMobileApp(context);
      case AdaptiveVariant.mobileWeb:
        return buildMobileWeb(context);
      case AdaptiveVariant.desktopApp:
        return buildDesktopApp(context);
      case AdaptiveVariant.desktopWeb:
        return buildDesktopWeb(context);
    }
  }
}

