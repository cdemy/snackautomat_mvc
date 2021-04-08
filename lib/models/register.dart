import 'package:snackautomat/models/_register.dart';

/// Concrete implementation of IRegister
class Register implements IRegister {
  final List<int> _coins;
  final List<int> _payout;
  final bool _adminMode;
  final int _debit;
  final String _message;
  final int _price;
  final int _producedSlot;
  final int _selectedSlot;

  @override
  List<int> get coins => _coins;
  @override
  List<int> get payout => _payout;
  @override
  bool get adminMode => _adminMode;
  @override
  int get debit => _debit;
  @override
  String get message => _message;
  @override
  int get price => _price;
  @override
  int get producedSlot => _producedSlot;
  @override
  int get selectedSlot => _selectedSlot;

  /// Constructor. Initializes Register object.
  Register({
    List<int>? coins,
    List<int>? payout,
    bool? adminMode,
    int? debit,
    String? message,
    int? price,
    int? producedSlot,
    int? selectedSlot,
  })  : _coins = coins ?? <int>[],
        _payout = payout ?? <int>[],
        _adminMode = adminMode ?? false,
        _debit = debit ?? 0,
        _message = message ?? 'Hallo Welt',
        _price = price ?? 0,
        _producedSlot = producedSlot ?? 0,
        _selectedSlot = selectedSlot ?? 0;

  /// Create new Register object by keeping most of the current attributes, just
  /// changing the ones that were given by parameters.
  @override
  Register copyWith({
    List<int>? coins,
    List<int>? payout,
    bool? adminMode,
    int? debit,
    String? message,
    int? price,
    int? producedSlot,
    int? selectedSlot,
  }) =>
      Register(
          coins: coins ?? _coins,
          payout: payout ?? [],
          adminMode: adminMode ?? _adminMode,
          debit: debit ?? _debit,
          message: message ?? _message,
          price: price ?? _price,
          producedSlot: producedSlot ?? _producedSlot,
          selectedSlot: selectedSlot ?? _selectedSlot);
}
