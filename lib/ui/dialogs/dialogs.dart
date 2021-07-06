import 'package:flutter/material.dart';

class AppDialogs {
  static PersistentBottomSheetController _imageSelectedController;


  static const defaultBottomSheetDecoration = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(31, 48, 48, 48),
        offset: Offset(0, -2),
        blurRadius: 5,
      ),
    ],
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
  );

  static Future<void> showLoadingDialog(BuildContext context,
      {RouteSettings routeSettings}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      routeSettings: routeSettings,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            constraints: BoxConstraints.expand(),
            color: Colors.white30,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepOrange),
            ),
          ),
        );
      },
    );
  }
}