import 'package:snackautomat/models/_register.dart';

/// Concrete implementation of IRegister
class Register implements IRegister {
  final List<int> _coins;
  final List<int> _payout;
  @override
  List<int> get coins => _coins;
  @override
  List<int> get payout => _payout;

  /// Constructor. Initializes Register object.
  Register({int? debit, List<int>? coins, List<int>? payout})
      : _coins = coins ?? <int>[],
        _payout = payout ?? <int>[];

  /// Create new Register object by keeping most of the current attributes, just
  /// changing the ones that were given by parameters.
  @override
  Register copyWith({int? debit, List<int>? coins, List<int>? payout}) => Register(
        coins: coins ?? _coins,
        payout: payout ?? [],
      );
}
