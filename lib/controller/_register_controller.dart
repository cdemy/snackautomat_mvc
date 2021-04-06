import 'package:snackautomat/models/register.dart';

abstract class IRegisterController {
  void selectProduct(int slot, int price);
  void insertCoin(int nom);
  void takeCoin(int nom);
  void reset();
  void adminMode([bool? isAdminMode]);

  bool get isAdminMode;
  int? get displayPrice;
  int? get displayDebit;
  int? get producedSlot;
  List<int> get coins;
  List<int> get payout;
}
