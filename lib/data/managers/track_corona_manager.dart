import 'package:servinformacion_test/data/apis/track_corona_api.dart';
import 'package:servinformacion_test/data/models/state_info_model.dart';

class TrackCoronaManager {

  static final get = TrackCoronaManager._();
  TrackCoronaManager._();

  final _trackCoronaApi = TrackCoronaApi.get;

  Future<List<StateInfoModel>> getAllStates() async {
    final response = await _trackCoronaApi.getAllStates();
    final states = response.data['data'] as List;
    return states.map((g) => StateInfoModel.fromJson(g)).toList();
  }

  Future<List<StateInfoModel>> getAllCitiesFromState(String state) async {
    final response = await _trackCoronaApi.getAllCitiesFromState(state);
    final states = response.data['data'] as List;
    return states.map((g) => StateInfoModel.fromJson(g)).toList();
  }

  Future<StateInfoModel> getUSInfo() async {
    final response = await _trackCoronaApi.getUSInfo();
    final state = response.data['data'] as List;
    return StateInfoModel.fromJson(state.first);
  }
}