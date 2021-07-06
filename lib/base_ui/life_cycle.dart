abstract class LifeCycle {

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  final List<Function> _listenersDisposed = [];

  void Function() _internalDispose;
  void Function() get internalDispose => _internalDispose;

  void Function(void Function() listener) _onDispose;
  void Function(void Function() listener) get onDispose => _onDispose;

  LifeCycle() {
    _internalDispose = () {
      if (!_isDisposed) {
        _isDisposed = true;
        this.dispose();
        if (_listenersDisposed.length > 0) {
          _listenersDisposed.forEach((f) {
            if (f != null) {
              f();
            }
          });
        }
        _listenersDisposed.clear();
      }
    };
    _onDispose = (listener) {
      if (listener != null) {
        _listenersDisposed.add(listener);
      }
    };
  }

  void dispose() {
    print('+++++lifecycle dispose++++++++++++++++++++++++');
  }
}