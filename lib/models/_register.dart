import 'package:snackautomat/models/register.dart';

class IRegister {
  List<int> _coins = [];
  List<int> _payout = [];
  List<int> get coins => _coins;
  List<int> get payout => _payout;

  factory IRegister() = Register;

  Register copyWith({int? debit, List<int>? coins, List<int>? payout}) => Register(
        coins: coins ?? _coins,
        payout: payout ?? _payout,
      );
}
