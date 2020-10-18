import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef String LoadError(PlatformException e);

typedef Widget PopupBuilder(
  Widget child, {
  String confirmText,
  String cancelText,
  Future<bool> Function() onConfirm,
});

typedef Widget LoadingBuilder<T>(
  Future<T> Function() onLoad,
  VoidCallback onTimeout,
  LoadError onError,
  bool confirm,
  String confirmText,
  int duration,
);

class NavigatorProvider<R extends PageRoute> {
  NavigatorProvider(
    this.navigatorState, {
    this.popupBuilder,
    this.loadingBuilder,
    this.confirmText = 'close',
    this.cancelText = 'cancel',
  });

  final String cancelText;
  final String confirmText;
  final NavigatorState navigatorState;
  final PopupBuilder popupBuilder;
  final LoadingBuilder loadingBuilder;

  Map<Type, Function> _routes = <Type, Function>{
    CupertinoPageRoute: (page) => CupertinoPageRoute(builder: (context) => page),
    MaterialPageRoute: (page) => MaterialPageRoute(builder: (context) => page),
  };

  Future<T> pushPage<T>(Widget page, {bool root = true}) async {
    return navigatorState.push<T>(_routes[R](page));
  }

  Future<T1> replacePage<T1, T2>(Widget page, {bool root = false, bool replaceAll = false}) {
    if (replaceAll) {
      navigatorState.popUntil((x) => x.isFirst);
    }
    return navigatorState.pushReplacement<T1, T2>(_routes[R](page));
  }

  showBottomPanel<T>(Widget widget, {bool popLast = false}) {
    if (popLast) pop();
    if (R is CupertinoPageRoute)
      showCupertinoModalPopup(
        context: navigatorState.context,
        builder: (BuildContext context) {
          return widget;
        },
      );
    else
      showBottomSheet<T>(context: navigatorState.context, builder: (BuildContext context) => widget);
  }

  // showBottomPanel(Widget widget,
  //     {bool popLast = false}) {
  //   if (popLast) navigatorState.pop();
  //   showModalBottomSheetApp(
  //       context: context, widget: widget, resizeToAvoidBottomPadding: false);
  // }

  Future<T1> replacePageWithName<T1, T2>(String routeName, {bool root = false, Object args}) {
    return navigatorState.pushReplacementNamed<T1, T2>(routeName, arguments: args);
  }

  Future<T> pushPageWithName<T>(String routeName, {bool root = false, Object args}) {
    return navigatorState.pushNamed<T>(routeName, arguments: args);
  }

  Future<T> loadRoute<T>(BuildContext context,
      {Future<T> Function() onLoad,
      VoidCallback onTimeout,
      LoadError onError,
      bool root = true,
      bool confirm = false,
      String confirmText,
      int duration = 20}) async {
    if (confirm) {
      bool res = await confirmPopup(confirmText: confirmText);
      if (!res) return null;
    }
    var res = await navigatorState.push<T>(PageRouteBuilder(
        maintainState: true,
        barrierDismissible: false,
        opaque: false,
        pageBuilder: (context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return this.loadingBuilder(onLoad, onTimeout, onError, confirm, confirmText ?? this.confirmText, duration);
        }));
    return res;
  }

  // Future<void> waitFor(BuildContext context, Duration duration) {
  //   return loadRoute(context, onLoad: () => Future.delayed(duration));
  // }

  Future<bool> confirmPopup({
    Widget child,
    String confirmText,
    String cancelText,
    Future<bool> Function() onConfirm,
  }) async {
    bool confirmed = await showDialog(
        barrierColor: Colors.black87,
        barrierDismissible: false,
        context: navigatorState.context,
        builder: (c) => this.popupBuilder(
              child,
              confirmText: confirmText ?? this.confirmText,
              cancelText: cancelText ?? this.cancelText,
              onConfirm: onConfirm,
            ));
    // assert(confirmed == true);
    return confirmed != null && confirmed;
  }

  void textPopup(BuildContext context, String text, {String confirmText}) {
    showDialog(
        barrierColor: Colors.black87,
        barrierDismissible: false,
        context: context,
        builder: (c) => this.popupBuilder(
              Text(text),
              confirmText: confirmText ?? this.confirmText,
            ));
  }

  void pop() {
    navigatorState.pop();
  }
}
