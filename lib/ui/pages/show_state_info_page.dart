import 'package:flutter/material.dart';
import 'package:servinformacion_test/base_ui/app_loading.dart';
import 'package:servinformacion_test/base_ui/base_page.dart';
import 'package:servinformacion_test/blocs/search_state_bloc.dart';
import 'package:servinformacion_test/data/models/state_info_model.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:servinformacion_test/ui/pages/home_page.dart';

class ShowStateInfoPage extends BasePage<SearchStateBloc>{
  ShowStateInfoPage(this.state) : super(SearchStateBloc(state));
  final StateInfoModel state;

  @override
  Widget pageBody(BuildContext context) {
    return createStateful(_StateGeoJsonInfo(state));
  }
}

class _StateGeoJsonInfo extends BaseState <SearchStateBloc, SharedStateful>{

  MapShapeSource _shapeSource;
  List<MapModel> _mapData;
  MapMarker marker;
  StateInfoModel selectedCity;

  @override
  void initState() {

    bloc.getStateCitiesInfo();
    _shapeSource = MapShapeSource.asset('assets/us-states.json',
      shapeDataField: 'COLORADO',);
    marker = MapMarker(latitude: state.latitude, longitude: state.longitude,
    iconType: MapIconType.circle,
    iconColor: Colors.red,
    size: Size(100,100),);
    selectedCity = state;
    super.initState();
  }

  final StateInfoModel state;
  _StateGeoJsonInfo(this.state);

  List<StateInfoModel> cities;

  @override
  Widget build(BuildContext context) {
    num size = MediaQuery.of(context).size.width-150;
    if(cities == null){
      return MediumLoading(
        color: Color(0xFF271C7C),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Color(0xFFC7C3EC),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(Icons.arrow_back_ios_outlined,
                    key: Key('search'),
                    color: Color(0xFF271C7C),
                    size: 25,),
                ),
              ),
              Text("Mapa "+state.nameCountry,
                style: TextStyle(
                  color: Color(0xFF271C7C),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,),
              SizedBox(
                width: 50,
                height: 50,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF271C7C),
                width: 2
              )
            ),
            clipBehavior: Clip.antiAlias,
            child: SfMaps(
              layers: [
                MapTileLayer(
                    urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                initialFocalLatLng: MapLatLng(state.latitude, state.longitude),
                initialZoomLevel: 6,
                markerBuilder: (context, int) {
                      num size = cities[int].confirmed/state.confirmed * 200;
                  return MapMarker(latitude: cities[int].latitude, longitude: cities[int].longitude,
                    iconType: MapIconType.circle,
                    iconColor: Colors.red.withOpacity(0.4),
                    size: Size(size,size),);
                },
                initialMarkersCount: cities.length,
                )
              ],),
          ),
          Container(
            height: 350,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: selectedCity!=null?Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Color(0xFF3D8BCE),
                          width: 1
                      )
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      focusColor: Color(0xFF261C7C).withOpacity(0.4),
                      isExpanded: true,
                      items: cities.map((StateInfoModel state){
                        return DropdownMenuItem(
                          value: state,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(state.nameCountry.split(',')[0],
                                style: TextStyle(
                                    color: Color(0xFF261C7C),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                ),),
                              Text(state.confirmed.toString(),
                                  style: TextStyle(
                                      color: Color(0xFF7A7A7A),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700
                                  ))
                            ],
                          ),
                        );
                      }).toList(),
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedCity.nameCountry.split(',')[0],
                            style: TextStyle(
                                color: Color(0xFF261C7C),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),),
                          Text(selectedCity.confirmed.toString(),
                              style: TextStyle(
                                  color: Color(0xFF7A7A7A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ))
                        ],
                      ),
                      onChanged: (value) =>{
                        setState(() {
                          selectedCity = value;
                        })
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Información general',
                        style: TextStyle(
                            color: Color(0xFF3D8BCE),
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                        textAlign: TextAlign.center,)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size*(selectedCity.recovered/selectedCity.confirmed),
                      height: 3,
                      color: Color(0xFF261C7C),
                    ),
                    Container(
                      width: size*(selectedCity.active/selectedCity.confirmed),
                      height: 3,
                      color: Color(0xFF3D8BCE),
                    ),
                    Container(
                      width: size*(selectedCity.dead/selectedCity.confirmed),
                      height: 3,
                      color: Color(0xFFED7264),
                    )
                  ],
                ),
                infoCovidWidget(selectedCity)
              ],
            ):MediumLoading(
              center: true,
              color: Color(0xFF261C7C),
            ),
          )
        ],
      )
      );
  }

  @override
  void initListeners() {
    bloc.observerCities.listen((value) {
      setState(() {
        _mapData = _getMapData(value);
        cities = value;
      });
    });
  }

  static List<MapModel> _getMapData(List<StateInfoModel> cities){
    return <MapModel>[
      ...cities.map((city){
        return MapModel(city.nameCountry, city.countryCode, Colors.deepOrange);
      })
    ];
  }
}

class MapModel{
  MapModel(this.city, this.stateCode, this.color);
  String city;
  String stateCode;
  Color color;
}