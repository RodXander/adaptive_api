import 'dart:async';

import 'package:build/build.dart';
import 'package:path/path.dart';

class AdaptiveBuilder extends Builder {
  static const preamble = "// GENERATED CODE - DO NOT MODIFY BY HAND";
  static const adaptiveApiName = 'adaptive_api.g.dart';
  static const adaptiveVariants = 'adaptive_variants';

  AdaptiveBuilder(this.options);

  final BuilderOptions options;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    var adaptiveAssetId = AssetId(buildStep.inputId.package, join('lib', adaptiveApiName));
    var sanitizedVariants = (options.config[adaptiveVariants] as String).split(',').map((variantStr) => variantStr.trim());

    await buildStep.writeAsString(adaptiveAssetId, '''
$preamble
${sanitizedVariants.join('.')}'''
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => { r'$lib$' : [adaptiveApiName] };

}