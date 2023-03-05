import 'dart:async';

import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

class AdaptiveBuilder extends Builder {
  static const _adaptiveApiName = 'adaptive_api.g.dart';
  static const _adaptiveVariant = 'AdaptiveVariant';
  static const _adaptiveBuilds = 'AdaptiveBuilds';
  static const _adaptiveStatelessWidget = 'AdaptiveStatelessWidget';
  static const _adaptiveStatefulWidget = 'AdaptiveStatefulWidget';
  static const _adaptiveState = 'AdaptiveState';

  AdaptiveBuilder(this.options) {
    // Sanitizing the input on the different variants
    _sanitizedVariants = (options.config['adaptive_variants'] as String)
        .split(',')
        .map((variantStr) => variantStr.trim())
        .where((variantStr) => variantStr.isNotEmpty)
        .toList();
    // Saving a version with capitalized names
    _sanitizedVariantsCap = _sanitizedVariants
        .map((variantStr) =>
            variantStr[0].toUpperCase() + variantStr.substring(1))
        .toList();
  }

  final BuilderOptions options;
  final DartFormatter _dartFormatter = DartFormatter();
  late final List<String> _sanitizedVariants;
  late final List<String> _sanitizedVariantsCap;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    // Getting the asset id for the adaptive api file and its buffer
    var adaptiveAssetId =
        AssetId(buildStep.inputId.package, join('lib', _adaptiveApiName));
    var stringBuffer = StringBuffer();

    // Writing the preamble for generated content
    stringBuffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND\n');

    // Creating and writing the necessary directives
    final directives = Directive.import('package:flutter/widgets.dart');
    stringBuffer
        .writeln(_dartFormatter.format('${directives.accept(DartEmitter())}'));

    // Writing some linter ignore clauses
    stringBuffer.writeln('// ignore_for_file: unused_element\n');

    // Creating and writing the AdaptiveVariants enum
    final adaptiveVariants = Enum((e) => e
      ..name = _adaptiveVariant
      ..values = ListBuilder([
        for (var variant in _sanitizedVariants)
          EnumValue((ev) => ev..name = variant)
      ]));
    stringBuffer.writeln(
        _dartFormatter.format('${adaptiveVariants.accept(DartEmitter())}'));

    // Creating and writing the AdaptiveBuilds class
    final adaptiveBuilds = Class((c) => c
      ..name = _adaptiveBuilds
      ..abstract = true
      ..methods = ListBuilder([
        for (var variant in _sanitizedVariantsCap)
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

    // Creating the AdaptiveStatelessWidget class
    final adaptiveStateless = Class((c) => c
      ..name = _adaptiveStatelessWidget
      ..abstract = true
      ..extend = const Reference('StatelessWidget')
      ..implements = ListBuilder([const Reference(_adaptiveBuilds)])
      ..fields = ListBuilder([_fieldVariant])
      ..constructors = _constructors
      ..methods = ListBuilder([_build()]));
    stringBuffer.writeln(
        _dartFormatter.format('${adaptiveStateless.accept(DartEmitter())}'));

    // Creating the AdaptiveStatefulWidget class
    final adaptiveStateful = Class((c) => c
      ..name = _adaptiveStatefulWidget
      ..abstract = true
      ..extend = const Reference('StatefulWidget')
      ..fields = ListBuilder([_fieldVariant])
      ..constructors = _constructors
      ..methods = ListBuilder([
        Method((m) => m
          ..annotations = ListBuilder([_overrideAnnotation])
          ..returns =
              const Reference('$_adaptiveState<$_adaptiveStatefulWidget>')
          ..name = 'createState')
      ]));
    stringBuffer.writeln(
        _dartFormatter.format('${adaptiveStateful.accept(DartEmitter())}'));

    // Creating the AdaptiveState class
    final adaptiveState = Class((c) => c
      ..name = '$_adaptiveState<T extends $_adaptiveStatefulWidget>'
      ..abstract = true
      ..extend = const Reference('State<T>')
      ..mixins = ListBuilder([const Reference(_adaptiveBuilds)])
      ..methods = ListBuilder([_build(onState: true)]));
    stringBuffer.writeln(
        _dartFormatter.format('${adaptiveState.accept(DartEmitter())}'));

    // Writing the file
    await buildStep.writeAsString(adaptiveAssetId, stringBuffer.toString());
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [_adaptiveApiName]
      };

  Field get _fieldVariant => Field((f) => f
    ..name = 'variant'
    ..modifier = FieldModifier.final$
    ..type = const Reference(_adaptiveVariant));

  ListBuilder<Constructor> get _constructors => ListBuilder([
        for (var variant in _sanitizedVariants)
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
                ListBuilder([Code('variant = $_adaptiveVariant.$variant')]))
      ]);

  Expression get _overrideAnnotation => const CodeExpression(Code('override'));

  Method _build({
    bool onState = false,
  }) {
    // Body for the build method of next class
    var buildBody = StringBuffer();
    buildBody.writeln('switch (${onState ? 'widget.' : ''}variant) {');
    for (int i = 0; i < _sanitizedVariants.length; i++) {
      buildBody.writeln('case $_adaptiveVariant.${_sanitizedVariants[i]}:');
      buildBody.writeln('return _build${_sanitizedVariantsCap[i]}(context);');
    }
    buildBody.writeln('}');

    // Creating the actual method
    return Method((m) => m
      ..annotations = ListBuilder([_overrideAnnotation])
      ..returns = const Reference('Widget')
      ..name = 'build'
      ..requiredParameters = ListBuilder([
        Parameter((p) => p
          ..type = const Reference('BuildContext')
          ..name = 'context')
      ])
      ..body = Code(buildBody.toString()));
  }
}
