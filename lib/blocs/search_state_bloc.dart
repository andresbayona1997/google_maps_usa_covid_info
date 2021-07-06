import 'package:servinformacion_test/base_ui/app_observer.dart';
import 'package:servinformacion_test/base_ui/base_bloc.dart';
import 'package:servinformacion_test/data/managers/track_corona_manager.dart';
import 'package:servinformacion_test/data/models/state_info_model.dart';

class SearchStateBloc extends BaseBloc{
  LifeObserver<List<StateInfoModel>> observerCities;
  final _trackCoronaManager = TrackCoronaManager.get;
  final StateInfoModel state;
  SearchStateBloc(this.state){
    observerCities = LifeObserver(this);
  }

  Future<void> getStateCitiesInfo() async {
    final states = await _trackCoronaManager.getAllCitiesFromState(state.nameCountry);
    observerCities.setValue(states);
  }



}