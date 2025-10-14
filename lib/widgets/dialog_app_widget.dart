import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogAppWidget {
  late FToast _fToast;

  void showsuccessToast(BuildContext context, String message) {
    _fToast = FToast(); // instantiate
    _fToast.init(context); // initialize

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: Colors.white),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child, gravity) => Positioned(
        top: 50.0,
        right: 16.0,
        child: child,
      ),
    );
  }

  void showwarningToast(BuildContext context, String message) {
    _fToast = FToast(); // instantiate
    _fToast.init(context); // initialize

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.orange.shade300,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning, color: Colors.white),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child, gravity) => Positioned(
        top: 50.0,
        right: 16.0,
        child: child,
      ),
    );
  }

  void errorToast(BuildContext context, String message) {
    _fToast = FToast(); // instantiate
    _fToast.init(context); // initialize

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.red.shade400,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child, gravity) => Positioned(
        top: 50.0,
        right: 16.0,
        child: child,
      ),
    );
  }
}
