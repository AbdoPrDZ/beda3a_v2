import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageHeaders {
  final String? title;
  final bool? participatesInRootNavigator;
  final double Function(BuildContext)? gestureWidth;
  final bool maintainState;
  final Curve curve;
  final Alignment? alignment;
  final Map<String, String>? parameters;
  final bool opaque;
  final Duration? transitionDuration;
  final bool? popGesture;
  final Bindings? binding;
  final List<Bindings> bindings = const [];
  final Transition? transition;
  final CustomTransition? customTransition;
  final bool fullScreenDialog;
  final bool showCupertinoParallax;
  final bool preventDuplicates;

  const PageHeaders({
    this.title,
    this.participatesInRootNavigator,
    this.gestureWidth,
    this.maintainState = true,
    this.curve = Curves.linear,
    this.alignment,
    this.parameters,
    this.opaque = true,
    this.transitionDuration,
    this.popGesture,
    this.binding,
    this.transition,
    this.customTransition,
    this.fullScreenDialog = false,
    this.showCupertinoParallax = true,
    this.preventDuplicates = true,
  });
}
