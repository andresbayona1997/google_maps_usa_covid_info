import 'package:bottom_sheet_x/widgets/stack_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:servinformacion_test/base_ui/app_loading.dart';
import 'package:servinformacion_test/base_ui/base_page.dart';
import 'package:servinformacion_test/blocs/home_bloc.dart';
import 'package:servinformacion_test/data/models/state_info_model.dart';
import 'package:servinformacion_test/ui/app_navigator.dart';
import 'package:servinformacion_test/ui/pages/search_state_page.dart';

class HomePage extends BasePage<HomeBloc>{
  HomePage() : super(HomeBloc());

  @override
  Widget pageBody(BuildContext context) {
    FocusNode focus = FocusNode();
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: createStateful(GoogleMapsState(focus))),
          ],
        ),
        // Positioned(
        //   top: 2,
        //   child: createStateful(SearchState(focus)),
        // )
      ],
    );
  }
}

class GoogleMapsState
    extends BaseState<HomeBloc, SharedStateful> with SingleTickerProviderStateMixin{


  
  LatLng initialIndications;
  CameraPosition initialPosition;
  Set<Circle> circles = new Set();
  List<StateInfoModel> states = [];
  StateInfoModel country;
  StateInfoModel selectedState;




  final ScrollController _scrollController = ScrollController();
  final StackBottomSheetController _stackBottomSheetController = StackBottomSheetController();

  final FocusNode focus;

  GoogleMapsState(this.focus);
  @override
  Widget build(BuildContext context) {

    Widget _bottomSheetHeader = ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        color: Color(0xFF261C7C),
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 6.0,
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    num size = MediaQuery.of(context).size.width-150;
    Widget _bottomSheetBody = ListView(
      controller: _scrollController,
      children: <Widget>[
        Container(
          height: 350,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: selectedState!=null?Column(
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
                      items: states.map((StateInfoModel state){
                        return DropdownMenuItem(
                          value: state,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(state.nameCountry,
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
                          Text(selectedState.nameCountry,
                            style: TextStyle(
                                color: Color(0xFF261C7C),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),),
                          Text(selectedState.confirmed.toString(),
                              style: TextStyle(
                                  color: Color(0xFF7A7A7A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ))
                        ],
                      ),
                      onChanged: (value) =>{
                        setState(() {
                          selectedState = value;
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
                    width: size*(selectedState.recovered/selectedState.confirmed),
                    height: 3,
                    color: Color(0xFF261C7C),
                  ),
                  Container(
                    width: size*(selectedState.active/selectedState.confirmed),
                    height: 3,
                    color: Color(0xFF3D8BCE),
                  ),
                  Container(
                    width: size*(selectedState.dead/selectedState.confirmed),
                    height: 3,
                    color: Color(0xFFED7264),
                  )
                ],
              ),
              infoCovidWidget(selectedState)
            ],
          ):MediumLoading(
            center: true,
            color: Color(0xFF261C7C),
          ),
        )
      ],
    );



    return StackBottomSheet(
      context: context,
      isDismissible: true,
      backdropColor: Colors.white.withOpacity(0.1),
      bottomSheetHeight: 400,
      bottomSheetHeader: _bottomSheetHeader,
      bottomSheetBody: _bottomSheetBody,
      bottomSheetBodyHasScrollView: true,
      bottomSheetBodyScrollController: _scrollController,
      body: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15,top: 10),
                  color: Colors.white,
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                      ),
                      Text("Mapa Global",
                      style: TextStyle(
                        color: Color(0xFF271C7C),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,),
                      Hero(
                        tag: 'search',
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> SearchStatePage(states: states,)));
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFFC7C3EC),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Icon(Icons.search,
                            key: Key('search'),
                            color: Color(0xFF271C7C),
                            size: 25,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(initialCameraPosition: initialPosition,
                  mapType: MapType.normal,
                  cameraTargetBounds: new CameraTargetBounds(
                    new LatLngBounds(southwest: LatLng(17.09024, -145.712891), northeast: LatLng(57.09024, -65.712891))
                  ),
                  circles: circles,
                  mapToolbarEnabled: true,
                  // onTap: (e){
                  //   //focus.requestFocus(focus);
                  //   focus.unfocus();
                  //   selectedState = null;
                  //   initialIndications = LatLng(37.09024, -95.712891);
                  //   setState(() { });
                  // },),
                )),
              ],
            ),
            // if(selectedState!=null && selectedState.nameCountry !='United States')
            //   Positioned.fill(
            //     child: Align(
            //       alignment: Alignment.center,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Container(
            //             constraints: BoxConstraints(
            //               maxWidth: MediaQuery.of(context).size.width-100
            //             ),
            //             padding: EdgeInsets.symmetric(horizontal: 40),
            //             decoration: BoxDecoration(
            //               color: Colors.white
            //             ),
            //             child: Text(selectedState.nameCountry,
            //               style: TextStyle(color: Colors.deepOrange,
            //                 fontSize: 14,),
            //             overflow: TextOverflow.ellipsis,
            //             maxLines: 2,
            //             textAlign: TextAlign.center,),
            //           ),
            //         ],
            //       ),
            //     ),
            //   )
          ],
        ),
      ), stackBottomSheetController: _stackBottomSheetController,
    );

  }

  @override
  void initState() {
    bloc.getUSInfo();
    super.initState();
    initialIndications = LatLng(37.09024, -95.712891);
    initialPosition = CameraPosition(target: initialIndications);
  }
  @override
  void initListeners() {
    bloc.observerStates.listen((value) {
      setState(() {
        for(var i = 0; i < value.length;i++){
          if(value[i].countryCode == 'us'){
            StateInfoModel state ;
            state = value[i];
            num percentage = 5000000 * state.confirmed/country.confirmed;
            Circle circle = new Circle(fillColor: Colors.red.withOpacity(0.5),
                center: LatLng(state.latitude,state.longitude),
                radius: percentage>200000?300000:percentage,
                circleId: CircleId(i.toString()),
                strokeWidth: 0,
            consumeTapEvents: true,
            onTap: (){
              this.selectCircleOfState(state);
            });
            circles.add(circle);
            states.add(state);
          }
        }
        states.sort((a,b){
          return a.nameCountry.toLowerCase().compareTo(b.nameCountry.toLowerCase());
        });
        states.insert(0, country);
      });
    });
    bloc.observerUS.listen((value) {
      setState(() {
        selectedState = value;
        country = value;
        bloc.getAllStates();
      });
    });
  }


  void selectCircleOfState(StateInfoModel state){
    initialIndications = LatLng(state.latitude, state.longitude);
    selectedState = state;
    _stackBottomSheetController.show();
    setState(() { });
  }
}



Widget infoState(StateInfoModel state){
  return Column(
    children: [
      Text(state.nameCountry),
      SizedBox(
        height: 20,
      )
    ],
  );
}

class SearchState
    extends BaseState<HomeBloc, SharedStateful> {

  List<StateInfoModel> states = [];
  final FocusNode focus;

  SearchState(this.focus);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
           onTap: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=> SearchStatePage(states: states,)));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Busca estado",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initListeners() {
    bloc.observerStates.listen((value) {
      setState(() {
        for(var i = 0; i < value.length;i++){
          if(value[i].countryCode == 'us'){
            states.add(value[i]);
          }
        }
      });
    });
  }

}

Widget covidInfo(List<StateInfoModel> states){

}

Widget infoCovidWidget(StateInfoModel selectedState){
  return Column(
    children: [
      SizedBox(
        height: 20,
      ),
      tileInfoWidget('Casos Activos', selectedState.active.toString(), 0xFF3D8BCE),
      SizedBox(
        height: 10,
      ),
      tileInfoWidget('Casos Recuperados', selectedState.recovered.toString(), 0xFF261C7C),
      SizedBox(
        height: 10,
      ),
      tileInfoWidget('Casos Mortales', selectedState.dead.toString(), 0xFFED7264),
    ],
  );
}

Widget tileInfoWidget(String descText, String cases, num color){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(Icons.circle,
            color: Color(color),
            size: 18,),
          SizedBox(
            width: 8,
          ),
          Text(descText,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF636363),
            ),)
        ],
      ),
      Text(cases == '0'?'N/D':cases,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF636363),
          ))
    ],
  );
}