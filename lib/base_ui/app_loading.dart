import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingBlurCover extends StatelessWidget {
  const LoadingBlurCover({
    @required this.isLoading,
    @required this.loadedChild,
    @required this.loadingChild,
    this.opacity = 0.2,
    this.onWillPop = _defaultOnWillPop,
  });
  final bool isLoading;
  final Widget loadedChild;
  final LoadingChild loadingChild;
  final double opacity;
  final Future<bool> Function() onWillPop;

  static Future<bool> _defaultOnWillPop() async => true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: isLoading ? onWillPop : null,
      child: GestureDetector(
        // Override gestures for closing bottom sheet
        onVerticalDragDown: isLoading ? (_) {} : null,
        onHorizontalDragDown: isLoading ? (_) {} : null,
        child: Stack(
          children: [
            // LOADED
            IgnorePointer(
              ignoring: isLoading,
              child: loadedChild,
            ),

            // LOADING
            Visibility(
              visible: isLoading,
              child: Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                  child: Container(
                    color: Colors.white.withOpacity(opacity),
                    child: Center(
                      child: loadingChild.render(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


abstract class LoadingChild {
  factory LoadingChild.widget(Widget widget) = _LoadingChildWidget._;
  factory LoadingChild.message(String message,
      {Color color, Color backgroundColor}) = _LoadingChildMessage._;
  factory LoadingChild.indicator({Color color}) = _LoadingChildIndicator._;

  Widget render();
}

class _LoadingChildWidget implements LoadingChild {
  const _LoadingChildWidget._(this.widget);
  final Widget widget;

  @override
  Widget render() => widget;
}

class _LoadingChildMessage implements LoadingChild {
  const _LoadingChildMessage._(
      this.message, {
        this.color = Colors.white,
        this.backgroundColor,
      });
  final String message;
  final Color color;
  final Color backgroundColor;

  @override
  Widget render() {
    Widget child = Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MediumLoading(color: color),
          const SizedBox(height: 40),
          Text(
            message,
            style: TextStyle(color: Colors.deepOrange, fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
    if (backgroundColor != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: child,
      );
    }
    return child;
  }
}

class _LoadingChildIndicator implements LoadingChild {
  const _LoadingChildIndicator._({this.color});
  final Color color;

  @override
  Widget render() => MediumLoading(color: color);
}


class MediumLoading extends StatelessWidget {
  const MediumLoading({
    Key key,
    Color color,
    this.padding,
    this.center = false,
    this.alignment,
    this.boxHeight,
    this.boxWidth,
  })  : this.color = color ?? Colors.white,
        super(key: key);

  final Color color;
  final EdgeInsetsGeometry padding;
  final bool center;
  final AlignmentGeometry alignment;
  final double boxHeight;
  final double boxWidth;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
    if (padding != null) {
      child = Padding(padding: padding, child: child);
    }
    if (alignment != null) {
      child = Align(alignment: alignment, child: child);
    } else if (center) {
      child = Center(child: child);
    }
    if (boxHeight != null || boxWidth != null) {
      child = SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: child,
      );
    }
    return child;
  }
}