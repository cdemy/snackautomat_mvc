import 'package:snackautomat/models/_register.dart';

class Register implements IRegister {
  List<int> _coins = [];
  List<int> _payout = [];
  List<int> get coins => _coins;
  List<int> get payout => _payout;

  Register({int? debit, List<int>? coins, List<int>? payout})
      : _coins = coins ?? <int>[],
        _payout = payout ?? <int>[];

  Register copyWith({int? debit, List<int>? coins, List<int>? payout}) => Register(
        coins: coins ?? _coins,
        payout: payout ?? [],
      );
}
