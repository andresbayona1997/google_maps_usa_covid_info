import 'package:servinformacion_test/data/managers/connectivity_manager.dart';

import 'app_observer.dart';
import 'life_cycle.dart';

abstract class BaseBloc extends LifeCycle {

  final _connectivityManager = ConnectivityManager.get;


  LifeObserver<bool> _observerNoInternet;


  BaseBloc() {
    _observerNoInternet = LifeObserver(this);
  }


  Future<bool> isNotConnected() async {
    bool isConnected = await _connectivityManager.getConnectivityState();
    if (!isConnected) {
      _observerNoInternet.setValue(true);
    }
    return !isConnected;
  }

  bool shouldShowNotification([String senderCode]) {
    return true;
  }

  bool shouldShowSupportButton(){
    return false;
  }

  bool shouldShowVideoRoomNowButton(){
    return false;
  }

  bool shouldShowRegisterBanner(){
    return true;
  }

  bool shouldShowAnimationSupportButton(){
    return false;
  }

  String namePageForSupportButton(){
    return "base_ui";
  }

  Function animationSupportButton(){
    Function function = (){};
    return function;
  }

  bool shouldGetVideoCallInfo() {
    return true;
  }

  bool redirectToVideoCall() {
    return true;
  }

  void dispose() {
    print('+++++bloc dispose++++++++++++++++++++++++');
  }
}