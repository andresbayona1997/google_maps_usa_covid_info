import 'package:flutter/material.dart';
import 'package:servinformacion_test/base_ui/base_bloc.dart';
import 'package:servinformacion_test/base_ui/provider.dart';
import 'package:servinformacion_test/ui/dialogs/dialogs.dart';

import 'app_loading.dart';

abstract class BasePage<B extends BaseBloc> extends StatelessWidget {

  final B bloc;


  BasePage(this.bloc,);

  Widget _pageBodyWrapper(BuildContext context) {
    return SafeArea(
      child: _BaseBodyStateful(
        page: this,
        child: pageBody(context),
      ),
    );
  }

  Widget pageBody(BuildContext context);

  Widget floatingButton(BuildContext context){
    return null;
  }

  Widget appBar(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = appBar(context);
    return Provider<B>(
      data: bloc,
      child: Scaffold(
        appBar: _appBar,
        primary: true,
        body: Builder(builder: (context) {
          return Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                decoration: decoration(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _pageBodyWrapper(context),
                    ),
                  ],
                ),
              ),
            ],
            overflow: Overflow.visible,
          );
        }),
        floatingActionButton: floatingButton(context),
      ),
    );
  }

  BoxDecoration decoration(BuildContext context) {

      final mq = MediaQuery.of(context);
      final stop = mq.padding.top / mq.size.height ;
      return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.red],
            tileMode: TileMode.clamp,
            stops: [stop, stop]
        ) ,
      );

  }

  SharedStateful createStateful<S extends BaseState<B, SharedStateful>>(S s) {
    s._initBloc(bloc);
    return SharedStateful(s);
  }

}

class SharedStateful<S extends State> extends StatefulWidget {
  final S state;

  SharedStateful(this.state, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return state;
  }

}


class _BaseBodyStateful extends StatefulWidget {

  final Widget child;
  final BasePage page;
  final ScaffoldState parentPageScaffold;

  const _BaseBodyStateful(
      {
        @required this.page,
        @required this.child,
        this.parentPageScaffold,
      }
      );

  @override
  State<StatefulWidget> createState() {
    final state = _BaseBodyState(this.page);
    state._initBloc(this.page.bloc);
    return state;
  }

}



class _BaseBodyState extends BaseState<BaseBloc, _BaseBodyStateful> with RouteAware {

  final BasePage page;
  final valueNotifierLoading = ValueNotifier<bool>(false);

  _BaseBodyState(this.page);

  @override
  void initListeners() {

  }

  @override
  void didPop() {
    super.didPop();
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  @override
  void didPush() {
    super.didPush();
  }

  @override
  void didPushNext() {
    super.didPushNext();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLoadingInherited(
      child: widget.child,
      parentPageScaffold: widget.parentPageScaffold ?? BaseLoadingInherited.of(context)?.parentPageScaffold,
      valueNotifierLoading: valueNotifierLoading,
    );
  }



  @override
  void dispose() {
    if (widget is _BaseBodyStateful) {
      if (_bloc != null) {
        _bloc.internalDispose();
        _bloc = null;
      }
    }
    valueNotifierLoading.dispose();
    super.dispose();
  }

}

abstract class BaseState<B extends BaseBloc, W extends StatefulWidget>
    extends State<W> {

  BaseLoadingInherited _loader;

  bool get _showLoading => _loader?._valueNotifierLoading?.value ?? false;
  set _showLoading(bool val) {
    if (_loader?._valueNotifierLoading != null) {
      _loader._valueNotifierLoading.value = val;
    }
  }


  @override
  void didChangeDependencies() {
    _loader = context.dependOnInheritedWidgetOfExactType<BaseLoadingInherited>();
    super.didChangeDependencies();
  }

  @protected
  void initInfo() {}

  @protected
  void initListeners();

  @override
  void initState() {
    super.initState();
  }

  @protected
  void showLoading() {
    if (!_showLoading) {
      _showLoading = true;
    }
  }


  @protected
  void hideLoading() {
    if (_showLoading) {
      _showLoading = false;
    }
  }

  B _bloc;

  _initBloc(B bloc) {
    _bloc = bloc;
    initInfo();
    initListeners();
  }

  B get bloc => _bloc;

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

}

class BaseLoadingInherited extends InheritedWidget {

  final ValueNotifier<bool> _valueNotifierLoading;
  final bool withDialog;
  final ScaffoldState parentPageScaffold;
  final BuildContext context;

  // ignore: prefer_const_constructors
  static final _loadingDialogRouteSettings = RouteSettings();

  BaseLoadingInherited({
    @required Widget child,
    @required ValueNotifier<bool> valueNotifierLoading,
    this.withDialog = false,
    this.context,
    this.parentPageScaffold,
  }): this._valueNotifierLoading = valueNotifierLoading,
        assert(!withDialog || context != null),
        super(child: withDialog ? child: _BaseAppLoadingAnimated(child: child));

  @override
  bool updateShouldNotify(BaseLoadingInherited old) {
    return _valueNotifierLoading.value != old._valueNotifierLoading.value;
  }

  void showLoading() {
    if (withDialog && !_valueNotifierLoading.value) {
      AppDialogs.showLoadingDialog(context, routeSettings: _loadingDialogRouteSettings).then((_){
        _valueNotifierLoading.value = false;
      });
    }
    _valueNotifierLoading.value = true;
  }

  void hideLoading() {
    if (withDialog && _valueNotifierLoading.value) {
      bool found = false;
      Navigator.popUntil(context, (route) {
        final previousFound = found;
        found = route.settings == _loadingDialogRouteSettings;
        return previousFound;
      });
    } else {
      _valueNotifierLoading.value = false;
    }
  }

  bool get isLoading => _valueNotifierLoading.value;

  static BaseLoadingInherited of(BuildContext c){
    return c.dependOnInheritedWidgetOfExactType<BaseLoadingInherited>();
  }

}

class _BaseAppLoadingAnimated extends StatelessWidget {

  final Widget child;

  _BaseAppLoadingAnimated({this.child});

  @override
  Widget build(BuildContext context) {
    final _loader = BaseLoadingInherited.of(context);
    final _valueNotifier = _loader._valueNotifierLoading;
    return AnimatedBuilder(
      animation: _valueNotifier,
      builder: (BuildContext context, Widget child) {
        return LoadingBlurCover(
          isLoading: _valueNotifier.value,
          loadedChild: child,
          loadingChild: LoadingChild.indicator(color: Colors.deepOrange),
          onWillPop: () async => false,
        );
      },
      child: child,
    );
  }

}