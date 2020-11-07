import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation_provider/src/loading_bloc.dart';

typedef String LoadError(Exception e);

typedef Widget PopupBuilder(
  Widget child, {
  String confirmText,
  String cancelText,
  Future<bool> Function() onConfirm,
});

typedef Widget LoadingBuilder<T>(
  Future<T> Function() onLoad,
  VoidCallback onTimeout,
  bool confirm,
  String confirmText,
  LoadError onError,
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
        // barrierColor: Colors.black54,
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

  Future<T> loadRoute<T>(
    BuildContext context, {
    @required Future<T> Function() onLoad,
    VoidCallback onTimeout,
    LoadError onError,
    bool popupError = false,
    bool confirm = false,
    String confirmText,
  }) async {
    if (confirm) {
      bool res = await confirmPopup(confirmText: confirmText);
      if (!res) return null;
    }

    context.bloc<LoadingBloc>().start();

    T result;

    try {
      result = await onLoad();
      // } on PlatformException catch (e) {
      //   exception = e;
      //   errorText = e.message;
      // } on SocketException catch (e) {
      //   exception = e;
      //   errorText = e.osError.message;
      // } on WebSocketException catch (e) {
      //   exception = e;
      //   errorText = e.message;
      //
    } catch (e) {
      if (onError != null) {
        onError(e);
      } else if (popupError) {
        var _errorText = e?.message ?? e.toString();
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
