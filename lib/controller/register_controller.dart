import 'package:snackautomat/controller/_register_controller.dart';
import 'package:snackautomat/models/_register.dart';

class RegisterController implements IRegisterController {
  IRegister _register = IRegister();
  bool _adminMode = false;
  int _displayPrice = 0;
  int _displayDebit = 0;

  void adminMode([bool? isAdminMode]) {
    if (adminMode == null) {}
    _adminMode = isAdminMode ?? !_adminMode;
  }

  void insertCoin(int denom) {
    final newCoins = [..._register.coins];
    newCoins.add(denom);
    newCoins.sort((a, b) => b.compareTo(a));
    if (!_adminMode) {
      _displayDebit += denom;
    }
    _register = _register.copyWith(coins: newCoins);
  }
}
