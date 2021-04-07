import 'package:snackautomat/controller/_register_controller.dart';
import 'package:snackautomat/models/_register.dart';

/// Controller between GUI and Register
class RegisterController implements IRegisterController {
  /// Message that is displayed most of the time
  static const stdMessage = 'Hallo Welt';

  /// Message that is displayed if the machine cant give out change
  static const stdPayExactly = 'Bitte passend(er) bezahlen';
  IRegister _register = IRegister();
  bool _adminMode = false;
  int _displayPrice = 0;
  int? _selectedSlot;
  int _displayDebit = 0;
  int? _producedSlot;
  String _message = stdMessage;

  @override
  int get displayDebit => _displayDebit;
  @override
  int get displayPrice => _displayPrice;
  @override
  bool get isAdminMode => _adminMode;
  @override
  int? get producedSlot => _producedSlot;
  @override
  int? get selectedSlot => _selectedSlot;
  @override
  List<int> get coins => _register.coins;
  @override
  List<int> get payout => _register.payout;
  @override
  String get message => _message;
  @override
  int get coinSum => coins.fold(0, (p, c) => p + c);
  @override
  int get payoutSum => payout.fold(0, (p, c) => p + c);

  @override
  void adminMode([bool? isAdminMode]) {
    _message = stdMessage;
    if (_displayDebit > 0) {
      throw CantSwitchToAdminModeWithDebit();
    }
    _adminMode = isAdminMode ?? !_adminMode;
  }

  @override
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

  @override
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

  @override
  void selectProduct(int slot, int price) {
    _message = stdMessage;
    if (_adminMode) return;
    _displayPrice = price;
    _selectedSlot = slot;
    _producedSlot = null;
    if (_displayDebit >= _displayPrice) _transaction();
  }

  @override
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

/// Exception that is thrown when we have no coins to satisfy the
/// wish of the user. Should never happen, we have other routines that check
/// before we initiate the process.
class DebitLeftButNoCoinsLeft implements Exception {}

/// Should never happen: A coin was removed in admin mode that never was registered.
class AdminTookCoinThatWasntThere implements Exception {}

/// When you have money in the machine, you cannot switch to admin mode.
class CantSwitchToAdminModeWithDebit implements Exception {}
