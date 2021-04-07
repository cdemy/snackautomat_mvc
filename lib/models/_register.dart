import 'package:snackautomat/models/register.dart';

/// Interface the Register class has to implement
abstract class IRegister {
  /// Coins that are where the user can take it (Ausgabeschacht)
  List<int> get payout;

  /// Coins that are in the machine for future transactions
  List<int> get coins;

  /// This central switch defaults to Register (which you have to implement).
  /// This way, the program can just create a new IRegister object. But, IRegister
  /// is abstract (which means it cannot be created). Instead, this factory
  /// lets Register create an object instead, which is possible because Register
  /// implements IRegister. This means that Register IS also of type IRegister.
  factory IRegister() = Register;

  /// We want Register to be an immutable state object. This means that all
  /// attributes are final. Instead of changing them, we just create a new
  /// Register object. With this method, we create a new Register object by
  /// reusing all old attributes, other than the ones we explicitly want to
  /// change.
  IRegister copyWith({int? debit, List<int>? coins, List<int>? payout});
}
