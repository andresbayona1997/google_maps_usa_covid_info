import 'package:rxdart/rxdart.dart';

import 'life_cycle.dart';

class LifeObserver<T> {

  T _value;
  bool _isValueProcessed = false;
  LifeCycle _life;
  BehaviorSubject<T> _subject;
  int _listenersLength = 0;
  int _listenersErrorLength = 0;
  final List<Function()> _onDisposeListeners = [];
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  LifeObserver(LifeCycle life) {
    _life = life;
    _subject = BehaviorSubject();
    _subject.sink.done.then((result) {
      if (_subject.hasListener && _value != null) {
        _isValueProcessed = true;
      }
    });
    life.onDispose(() {
      if (_isDisposed) return;
      _subject.close();
      _onDisposeListeners.forEach((f) => f());
      _isDisposed = true;
    });
  }

  void setValue(T value) {
    if (value != null && !_subject.isClosed && !_life.isDisposed) {
      _value = value;
      _isValueProcessed = false;
      _subject.sink.add(_value);
    }
  }



  void listen(void Function(T value) listener,
      {void Function() listenError}) {
    if (!_life.isDisposed) {
      if (listener != null && !_subject.isClosed) {
        _subject.stream.listen(listener);
        _listenersLength++;
      }
      if (listenError != null) {
        _listenersErrorLength++;
      }
    }
  }

  void listenCached(void Function(T value) listener,
      {void Function() listenError}) {
    if (!_life.isDisposed) {
      if (listener != null && !_subject.isClosed && _value != null) {
        listener(_value);
      }
    }
  }

  void onDispose(void Function() listener) {
    if (listener == null) return;
    _onDisposeListeners.add(listener);
    if (_isDisposed) {
      listener();
    }
  }

}