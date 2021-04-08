import 'dart:developer';

import 'package:snackautomat/controller/_register_controller.dart';
import 'package:snackautomat/models/_register.dart';

/// Controller between GUI and Register
class RegisterController implements IRegisterController {
  /// Message that is displayed most of the time
  static const stdMessage = 'Hallo Welt';

  /// Message that is displayed if the machine cant give out change
  static const stdPayExactly = 'Bitte passend(er) bezahlen';
  IRegister _register = IRegister();

  @override
  int get displayDebit => _register.debit;
  @override
  int get displayPrice => _register.price;
  @override
  bool get isAdminMode => _register.adminMode;
  @override
  int get producedSlot => _register.producedSlot;
  @override
  int get selectedSlot => _register.selectedSlot;
  @override
  List<int> get coins => _register.coins;
  @override
  List<int> get payout => _register.payout;
  @override
  String get message => _register.message;
  @override
  int get coinSum => coins.fold(0, (p, c) => p + c);
  @override
  int get payoutSum => payout.fold(0, (p, c) => p + c);

  @override
  void adminMode([bool? value]) {
    log('RegisterController: Execute: adminMode($value)');
    if (displayDebit > 0) {
      throw CantSwitchToAdminModeWithDebit();
    }
    final newAdminMode = value ?? !isAdminMode;
    _register = _register.copyWith(adminMode: newAdminMode);
  }

  @override
  void insertCoin(int denom) {
    log('RegisterController: Execute: insertCoin($denom)');
    final newCoins = [..._register.coins];
    newCoins.add(denom);
    newCoins.sort((a, b) => b.compareTo(a));
    var newDebit = displayDebit;
    if (!isAdminMode) {
      newDebit += denom;
    }
    // Update register
    _register = _register.copyWith(coins: newCoins, debit: newDebit);
    if (selectedSlot > 0 && displayDebit >= displayPrice) _transaction();
  }

  bool _isTransactionPossible() {
    log('RegisterController: Execute: _isTransactionPossible()');
    if (selectedSlot == 0) return false;
    if (displayDebit < displayPrice) return false;
    if (displayPrice <= 0) return false;
    var rest = displayDebit - displayPrice;
    final newCoins = [..._register.coins]..sort((a, b) => b.compareTo(a));
    for (var i = 0; i < newCoins.length && rest > 0; i++) {
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
    log('RegisterController: Execute: reset()');
    // Hand out debit
    final newCoins = [..._register.coins]..sort((a, b) => b.compareTo(a));
    final newPayout = <int>[];
    var newDebit = displayDebit;
    for (var i = 0; i < newCoins.length && newDebit > 0; i++) {
      if (newDebit >= newCoins[i]) {
        newDebit -= newCoins[i];
        newPayout.add(newCoins[i]);
        newCoins.remove(newCoins[i]);
        i--;
      }
    }
    if (newDebit > 0) throw DebitLeftButNoCoinsLeft();
    // Update Register
    _register = _register.copyWith(coins: newCoins, payout: newPayout, debit: newDebit, selectedSlot: 0, producedSlot: 0, price: 0);
  }

  @override
  void selectProduct(int slot, int price) {
    log('RegisterController: Execute: selectProduct($slot, $price)');
    if (isAdminMode) return;
    _register = _register.copyWith(price: price, selectedSlot: slot);
    if (displayDebit >= displayPrice) _transaction();
  }

  @override
  void statusReport() {
    log('------------------------------');
    log('* Register Controller Status');
    log('* debit / price: $displayDebit -> $displayPrice');
    log('* coins: $coinSum -> $coins');
    log('* coins: $coinSum -> $coins');
    log('* payout: $payoutSum -> $payout');
    log('* product selected / produced: $selectedSlot, $producedSlot');
    log('------------------------------');
  }

  @override
  void takeCoin(int denom) {
    log('RegisterController: Execute: takeCoin($denom)');
    if (isAdminMode) return;
    final newCoins = [..._register.coins]..sort((a, b) => b.compareTo(a));
    if (!newCoins.remove(denom)) {
      //throw AdminTookCoinThatWasntThere();
      return;
    }
    _register = _register.copyWith(coins: newCoins, payout: [denom]);
  }

  void _transaction() {
    log('RegisterController: Execute: _transaction');
    if (!_isTransactionPossible()) {
      _register = _register.copyWith(message: stdPayExactly);
      return;
    }
    // Just reduce debit. User can abort process if he wants his money back.
    final newDebit = displayDebit - displayPrice;
    _register = _register.copyWith(
      debit: newDebit,
      price: 0,
      producedSlot: selectedSlot,
      selectedSlot: 0,
    );
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
