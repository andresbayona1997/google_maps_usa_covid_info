import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servinformacion_test/data/models/state_info_model.dart';
import 'package:servinformacion_test/ui/pages/search_state_page.dart';

import '../main.dart';

class AppNavigator {
  AppNavigator._();


  static void gotoSearchStatePage(BuildContext c, List<StateInfoModel> states) {
    _gotoPush(c, SearchStatePage(states: states,), 'search_state_page');
  }

  static Future<Object> _gotoPush<P extends StatelessWidget>(
      BuildContext c, P page, String pageName) {
    NavigatorState nav;
    try {
      nav = Navigator.maybeOf(c);
    } catch (e) {}
    if (nav == null) {
      nav = globalNavigatorKey.currentState;
    }

    return nav.push(
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
        settings: RouteSettings(name: pageName),
      ),
    );
  }
}