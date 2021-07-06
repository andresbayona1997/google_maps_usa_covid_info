import 'package:flutter/material.dart';

class Provider<T> extends InheritedWidget {
  final T data;

  const Provider({
    @required this.data,
    Widget child,
    Key key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(Provider<T> oldWidget) {
    return oldWidget.data != this.data;
  }

  static T of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<T>>()?.data;
  }

  static T get<T>(BuildContext context) {
    final _widget =
        context.getElementForInheritedWidgetOfExactType<Provider<T>>().widget;
    return (_widget as Provider).data as T;
  }
}