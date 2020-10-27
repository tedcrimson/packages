import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation_provider/src/loading_bloc.dart';

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

  Future<T> showBottomPanel<T>(Widget widget, {bool popLast = false}) {
    if (popLast) pop();
    if (R is MaterialPageRoute<dynamic>) {
      return showModalBottomSheet<T>(context: navigatorState.context, builder: (BuildContext context) => widget);
    } else
      return showCupertinoModalPopup<T>(
        context: navigatorState.context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return widget;
        },
      );
  }

  // showBottomPanel(Widget widget,
  //     {bool popLast = false}) {
  //   if (popLast) navigatorState.pop();
  //   showModalBottomSheetApp(
  //       context: context, widget: widget, resizeToAvoidBottomPadding: false);
  // }

  Future<T> loadRoute<T>(BuildContext context,
      {@required Future<T> Function() onLoad,
      VoidCallback onTimeout,
      LoadError onError,
      bool confirm = false,
      String confirmText,
      int duration = 20}) async {
    if (confirm) {
      bool res = await confirmPopup(confirmText: confirmText);
      if (!res) return null;
    }

    context.bloc<LoadingBloc>().start();

    T result;
    try {
      result = await onLoad();
    } catch (e) {
      if (onError != null) {
        var _errorText = onError(e);
        textPopup(
          context,
          _errorText,
        );
      }
    } finally {
      context.bloc<LoadingBloc>().end();
    }

    // var res = await navigatorState.push<T>(PageRouteBuilder(
    //     maintainState: true,
    //     barrierDismissible: false,
    //     opaque: false,
    //     pageBuilder: (context, Animation<double> animation, Animation<double> secondaryAnimation) {
    //       return this.loadingBuilder(onLoad, onTimeout, onError, confirm, confirmText ?? this.confirmText, duration);
    //     }));
    return result;
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

extension BuildContextExt on BuildContext {
  // static Map<Type, Function> _routes = <Type, Function>{
  //   CupertinoPageRoute: (page) => CupertinoPageRoute(builder: (context) => page),
  //   MaterialPageRoute: (page) => ),
  // };
  // static Function _getRoute(BuildContext context) {
  //   return _routes[NavigatorProvider.of(context).type];
  // }

  Future<T> pushPage<T>(Widget page, {bool root = !kIsWeb}) async {
    return Navigator.of(this, rootNavigator: root).push<T>(MaterialPageRoute(builder: (context) => page));
  }

  Future<T1> replacePage<T1, T2>(Widget page, {bool root = false, bool replaceAll = false}) {
    NavigatorState navigatorState = Navigator.of(this);
    if (replaceAll) {
      navigatorState.popUntil((x) => x.isFirst);
    }
    return navigatorState.pushReplacement<T1, T2>(MaterialPageRoute(builder: (context) => page));
  }

  Future<T1> replacePageWithName<T1, T2>(String routeName, {bool root = false, Object args}) {
    return Navigator.of(this).pushReplacementNamed<T1, T2>(routeName, arguments: args);
  }

  Future<T> pushPageWithName<T>(String routeName, {bool root = false, Object args}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: args);
  }
}
