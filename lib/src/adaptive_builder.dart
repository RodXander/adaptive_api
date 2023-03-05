import 'dart:async';

import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

class AdaptiveBuilder extends Builder {
  static const adaptiveApiName = 'adaptive_api.g.dart';

  AdaptiveBuilder(this.options);

  final BuilderOptions options;
  final DartFormatter _dartFormatter = DartFormatter();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    // Getting the asset id for the adaptive api file and its buffer
    var adaptiveAssetId =
        AssetId(buildStep.inputId.package, join('lib', adaptiveApiName));
    var stringBuffer = StringBuffer();

    // Writing the preamble for generated content
    stringBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND\n');

    // Creating and writing the necessary directives
    final directives = Directive.import('package:flutter/widgets.dart');
    stringBuffer
        .writeln(_dartFormatter.format('${directives.accept(DartEmitter())}'));

    // Writing some linter ignore clauses
    stringBuffer.writeln('// ignore_for_file: unused_element\n');

    // Sanitizing the input on the different variants
    var sanitizedVariants = (options.config['adaptive_variants'] as String)
        .split(',')
        .map((variantStr) => variantStr.trim())
        .where((variantStr) => variantStr.isNotEmpty)
        .toList();
    // Saving a version with capitalized names
    var sanitizedVariantsCap = sanitizedVariants
        .map((variantStr) =>
            variantStr[0].toUpperCase() + variantStr.substring(1))
        .toList();

    // Creating and writing the AdaptiveVariants enum
    final adaptiveVariants = Enum((e) => e
      ..name = 'AdaptiveVariant'
      ..values = ListBuilder([
        for (var variant in sanitizedVariants)
          EnumValue((ev) => ev..name = variant)
      ]));
    stringBuffer.writeln(
        _dartFormatter.format('${adaptiveVariants.accept(DartEmitter())}'));

    // Creating and writing the AdaptiveBuilds class
    final adaptiveBuilds = Class((c) => c
      ..name = 'AdaptiveBuilds'
      ..abstract = true
      ..methods = ListBuilder([
        for (var variant in sanitizedVariantsCap)
          Method((m) => m
            ..name = '_build$variant'
            ..returns = const Reference('Widget')
            ..requiredParameters = ListBuilder([
              Parameter((p) => p
                ..name = 'context'
                ..type = const Reference('BuildContext'))
            ]))
      ]));
    stringBuffer.writeln(
        _dartFormatter.format('${adaptiveBuilds.accept(DartEmitter())}'));

    // Body for the build method of next class
    var buildBody = StringBuffer();
    buildBody.writeln('switch (variant) {');
    for (int i = 0; i < sanitizedVariants.length; i++) {
      buildBody.writeln('case AdaptiveVariant.${sanitizedVariants[i]}:');
      buildBody.writeln('return _build${sanitizedVariantsCap[i]}(context);');
    }
    buildBody.writeln('}');

    // Creating the AdaptiveStatelessWidget class
    final adaptiveStateless = Class((c) => c
      ..name = 'AdaptiveStatelessWidget'
      ..abstract = true
      ..extend = const Reference('StatelessWidget')
      ..implements = ListBuilder([const Reference('AdaptiveBuilds')])
      ..fields = ListBuilder([
        Field((f) => f
          ..name = 'variant'
          ..modifier = FieldModifier.final$
          ..type = const Reference('AdaptiveVariant'))
      ])
      ..constructors = ListBuilder([
        for (var variant in sanitizedVariants)
          Constructor((c) => c
            ..constant = true
            ..name = variant
            ..optionalParameters = ListBuilder([
              Parameter((p) => p
                ..toSuper = true
                ..named = true
                ..name = 'key')
            ])
            ..initializers =
                ListBuilder([Code('variant = AdaptiveVariant.$variant')]))
      ])
      ..methods = ListBuilder([
        Method((m) => m
          ..annotations = ListBuilder([const CodeExpression(Code('override'))])
          ..returns = const Reference('Widget')
          ..name = 'build'
          ..requiredParameters = ListBuilder([
            Parameter((p) => p
              ..type = const Reference('BuildContext')
              ..name = 'context')
          ])
          ..body = Code(buildBody.toString()))
      ]));
    stringBuffer.writeln(
        _dartFormatter.format('${adaptiveStateless.accept(DartEmitter())}'));

    // Writing the file
    await buildStep.writeAsString(adaptiveAssetId, stringBuffer.toString());
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [adaptiveApiName]
      };
}
