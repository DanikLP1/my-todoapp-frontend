import 'package:flutter/material.dart';

class SnackBarUtil {
  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.only(top: 70, left: 10, right: 10),
      dismissDirection: DismissDirection.up,
    );
  }

  static SnackBar successSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.only(top: 70, left: 10, right: 10),
      dismissDirection: DismissDirection.up,
    );
  }
}