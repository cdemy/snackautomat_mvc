import 'package:snackautomat/controller/register_controller.dart';

/// This is what we would call an interface, even though Dart does not know
/// the word "interface" in its language. But it knows the keyword "implements",
/// which is what you would do with an interface in C# or Java.
/// Implementing a class / interface means that you sign up to a contract of
/// what methods you will offer to the user.
/// I want you to define RegisterController which implements IRegisterController.
/// This will force you to implement all of the methods mentioned here.
/// The idea is to leave the interface unchanged.
abstract class IRegisterController {
  /// User chooses a product. If he already put in enough money, he will get
  /// that product (indicated in [producedSlot]), otherwise it will just show
  /// the price, remember the choice in [selectedSlot] and wait for more money
  /// to come.
  void selectProduct(int slot, int price);

  /// User inserts a coin of a certain nomination. His debit will raise. If it
  /// is enough to pay for [selectedSlot], the transaction will be executed.
  /// In admin mode, this means we restock the coins.
  void insertCoin(int nom);

  /// Prints status report about the relevant data
  void statusReport();

  /// Only if [isAdminMode] is true: The admin takes a coin out of the automat.
  void takeCoin(int nom);

  /// The user aborts the whole process. He gets back his money.
  void reset();

  /// Enters presses the secret switch or enters the secret code. He now has
  /// admin control. He can insert coins without accumulating debit. He can
  /// take money out of the machine.
  // ignore: avoid_positional_boolean_parameters
  void adminMode([bool? isAdminMode]);

  /// Our GUI wants to know how much money was already inserted
  int get displayDebit;

  /// Our GUI wants to know what the product we are aiming for costs
  int get displayPrice;

  /// We need to know if we are in admin mode or not
  bool get isAdminMode;

  /// This message is on the display, all of the time. It usually is "Hallo Welt",
  /// but this might change for error messages or something like "bitte passend einwerfen"
  String get message;

  /// If this is not null, it means we just bought an item and this is now where
  /// the user can get it (Ausgabeschacht).
  int get producedSlot;

  /// The slot the user aims for, until the price is payed. Resets to null if
  /// the user aborts the process or actually buys the product.
  int get selectedSlot;

  /// All the coins in the machine, it should always be a sorted list of denominations.
  List<int> get coins;

  /// All the coins that are thrown out as change or because the user aborted the
  /// process.
  List<int> get payout;

  /// The sum of the denominations of all coins in the coin repository
  int get coinSum;

  /// The sum of the denominations of all coins that can be grabbed by the user (Ausgabeschacht)
  int get payoutSum;

  /// When somebody tries to instantiate IRegisterController, RegisterController
  /// will be used instead - a redirected constructor.
  factory IRegisterController() = RegisterController;
}
