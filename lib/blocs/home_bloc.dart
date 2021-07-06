import 'package:servinformacion_test/base_ui/app_observer.dart';
import 'package:servinformacion_test/base_ui/base_bloc.dart';
import 'package:servinformacion_test/data/managers/track_corona_manager.dart';
import 'package:servinformacion_test/data/models/state_info_model.dart';

class HomeBloc extends BaseBloc{

  final _trackCoronaManager = TrackCoronaManager.get;
  LifeObserver<List<StateInfoModel>> observerStates;
  LifeObserver<StateInfoModel> observerUS;

  HomeBloc(){
    observerStates = LifeObserver(this);
    observerUS = LifeObserver(this);
  }

  Future<void> getUSInfo() async {
    final states = await _trackCoronaManager.getUSInfo();
    observerUS.setValue(states);
  }

  Future<void> getAllStates() async {
    final states = await _trackCoronaManager.getAllStates();
    observerStates.setValue(states);
  }
}