import 'package:dio/dio.dart';

class TrackCoronaApi {

  static final get = TrackCoronaApi._();

  TrackCoronaApi._();
  var dio = Dio();

  Future<Response> getAllStates() async{
    final response = await dio.get('https://www.trackcorona.live/api/provinces');
    return response;
  }

  Future<Response> getAllCitiesFromState(String state) async{
    final response = await dio.get('https://www.trackcorona.live/api/cities/'+state);
    return response;
  }

  Future<Response> getUSInfo() async{
    final response = await dio.get('https://www.trackcorona.live/api/countries/us');
    return response;
  }
}