import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:servinformacion_test/base_ui/base_page.dart';
import 'package:servinformacion_test/blocs/search_state_bloc.dart';
import 'package:servinformacion_test/data/models/state_info_model.dart';
import 'package:servinformacion_test/ui/pages/show_state_info_page.dart';

class SearchStatePage extends BasePage<SearchStateBloc>{
  final List<StateInfoModel> states;
  SearchStatePage({this.states}) : super(SearchStateBloc(null));

  @override
  Widget pageBody(BuildContext context) {
    return Container(
      color: Colors.white,
        child: createStateful(_SearchState(states)));
  }

}

class _SearchState extends BaseState <SearchStateBloc, SharedStateful>{

  final List<StateInfoModel> states;

  List<StateInfoModel> filteredStates = [];
  FocusNode focus = FocusNode();
  TextEditingController _controller = new TextEditingController();

  _SearchState(this.states);
  @override
  Widget build(BuildContext context) {
    focus.requestFocus();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: focus,
                    decoration: InputDecoration(
                      hintText: 'Busca el estado...',
                      hintStyle: TextStyle(color: Colors.black,
                      fontSize: 18),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only( right: 20),
                        child: GestureDetector(
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
                            child: Icon(Icons.arrow_back_ios,
                              key: Key('search'),
                              color: Color(0xFF271C7C),
                              size: 25,),
                          ),
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: (){
                            filteredStates = states;
                          },
                          child: Hero(
                            tag: 'search',
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
                        ),
                      ),
                    ),
                    onChanged: (text){
                      filteredStates = [];
                      for(var i=0 ; i<states.length;i++){
                        StateInfoModel state = states[i];
                        if(state.nameCountry.toLowerCase().contains(_controller.text.toLowerCase())){
                          filteredStates.add(state);
                        }
                      }
                      setState(() { });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ...filteredStates.map((state){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> ShowStateInfoPage(state,)));
                  },
                    child: stateItemWidget(state));
              })
            ],
          )
        )
      ],
    );

  }

  @override
  void initState() {
    filteredStates = states;
    setState(() { });
    super.initState();
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

}


Widget stateItemWidget(StateInfoModel state){
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25)
        ),
        child: Row(
          children: [
            Text(state.nameCountry,
              style: TextStyle(
                color: Color(0xFF271C7C),
                fontSize: 16,
              ),)
          ],
        ),
      ),
    ],
  );
}