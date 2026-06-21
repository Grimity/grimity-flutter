import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates [LayerLink] that will be disposed automatically.
LayerLink useLayerLink() {
  return use(_LayerLinkHook());
}

class _LayerLinkHook extends Hook<LayerLink> {
  const _LayerLinkHook();

  @override
  HookState<LayerLink, Hook<LayerLink>> createState() => _LayerLinkHookState();
}

class _LayerLinkHookState extends HookState<LayerLink, _LayerLinkHook> {
  late final layerLink = LayerLink();

  @override
  LayerLink build(BuildContext context) => layerLink;

  @override
  String get debugLabel => 'useLayerLink';
}
