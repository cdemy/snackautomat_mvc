import 'package:snackautomat/controller/_register_controller.dart';
import 'package:snackautomat/models/_register.dart';

class RegisterController implements IRegisterController {
  static const stdMessage = 'Hallo Welt';
  static const stdPayExactly = 'Bitte passend(er) bezahlen';
  IRegister _register = IRegister();
  bool _adminMode = false;
  int _displayPrice = 0;
  int? _selectedSlot;
  int _displayDebit = 0;
  int? _producedSlot;
  String _message = stdMessage;

  int get displayDebit => _displayDebit;
  int? get selectedSlot => _selectedSlot;
  int get displayPrice => _displayPrice;
  bool get isAdminMode => _adminMode;
  int? get producedSlot => _producedSlot;
  List<int> get coins => _register.coins;
  List<int> get payout => _register.payout;
  String get message => _message;

  void adminMode([bool? isAdminMode]) {
    _message = stdMessage;
    if (_displayDebit > 0) {
      throw CantTakeCoinsWithDebitActive();
    }
    _adminMode = isAdminMode ?? !_adminMode;
  }

  void insertCoin(int denom) {
    _message = stdMessage;
    final newCoins = [..._register.coins];
    newCoins.add(denom);
    newCoins.sort((a, b) => b.compareTo(a));
    if (!_adminMode) {
      _displayDebit += denom;
    }
    // Update register
    _register = _register.copyWith(coins: newCoins);
    _producedSlot = null;
    if (_selectedSlot != null && _displayDebit >= _displayPrice) _transaction();
  }

  bool _isTransactionPossible() {
    if (_selectedSlot == null) return false;
    if (_displayDebit < _displayPrice) return false;
    if (_displayPrice <= 0) return false;
    var rest = _displayDebit - _displayPrice;
    final newCoins = [..._register.coins]..sort((a, b) => b.compareTo(a));
    for (var i = 0; i < newCoins.length && _displayDebit > 0; i++) {
      if (rest >= newCoins[i]) {
        rest -= newCoins[i];
        newCoins.remove(newCoins[i]);
        i--;
      }
    }
    if (rest > 0) return false;
    return true;
  }

  void reset() {
    _message = stdMessage;
    // Hand out debit
    final newCoins = [..._register.coins]..sort((a, b) => b.compareTo(a));
    final newPayout = <int>[];
    for (var i = 0; i < newCoins.length && _displayDebit > 0; i++) {
      if (_displayDebit >= newCoins[i]) {
        _displayDebit -= newCoins[i];
        newPayout.add(newCoins[i]);
        newCoins.remove(newCoins[i]);
        i--;
      }
    }
    if (_displayDebit > 0) throw DebitLeftButNoCoinsLeft();
    // Update Register
    _register = _register.copyWith(coins: newCoins, payout: newPayout);
    // Reset everything else
    _adminMode = false;
    _selectedSlot = null;
    _producedSlot = null;
    _displayPrice = 0;
  }

  void selectProduct(int slot, int price) {
    _message = stdMessage;
    if (_adminMode) return;
    _displayPrice = price;
    _selectedSlot = slot;
    _producedSlot = null;
    if (_displayDebit >= _displayPrice) _transaction();
  }

  void takeCoin(int denom) {
    _message = stdMessage;
    if (!_adminMode) return;
    final newCoins = [..._register.coins]..sort((a, b) => b.compareTo(a));
    if (!newCoins.remove(denom)) {
      //throw AdminTookCoinThatWasntThere();
      return;
    }
    _register = _register.copyWith(coins: newCoins, payout: [denom]);
  }

  void _transaction() {
    _message = stdMessage;
    if (!_isTransactionPossible()) {
      _message = stdPayExactly;
      return;
    }
    // Hand out rest
    _displayDebit -= _displayPrice;
    final newCoins = [..._register.coins]..sort((a, b) => b.compareTo(a));
    final newPayout = <int>[];
    for (var i = 0; i < newCoins.length && _displayDebit > 0; i++) {
      if (_displayDebit >= newCoins[i]) {
        _displayDebit -= newCoins[i];
        newPayout.add(newCoins[i]);
        newCoins.remove(newCoins[i]);
        i--;
      }
    }
    if (_displayDebit > 0) throw DebitLeftButNoCoinsLeft();
    // Update Register
    _register = _register.copyWith(coins: newCoins, payout: newPayout);
    // Reset everything else
    _adminMode = false;
    _producedSlot = _selectedSlot;
    _selectedSlot = null;
    _displayPrice = 0;
  }
}

class DebitLeftButNoCoinsLeft implements Exception {}

class AdminTookCoinThatWasntThere implements Exception {}

class CantTakeCoinsWithDebitActive implements Exception {}
