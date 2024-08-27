import 'package:flutter/foundation.dart';
import 'package:rieu/presentation/providers/providers.dart';

class RouterProvider extends ChangeNotifier {
  final AuthProvider _authProvider;

  RouterProvider(this._authProvider) {
    _authProvider.addListener(notifyListeners);
  }

  AuthStatus get authStatus => _authProvider.state.status;

  @override
  void dispose() {
    _authProvider.removeListener(notifyListeners);
    super.dispose();
  }
}