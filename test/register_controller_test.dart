import 'package:flutter_test/flutter_test.dart';
import 'package:snackautomat/controller/_register_controller.dart';

import 'test_basis.dart';

void main() {
  test('RC kann erstellt werden', () {
    final rc = IRegisterController();
    expect(rc == null, false);
  });

  test('RC hat Standardwerte nach Erstellung', () {
    final rc = IRegisterController();
    expect(rc.displayDebit, 0);
    expect(rc.displayPrice, 0);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, null);
    expect(rc.selectedSlot, null);
    expect(eq(rc.coins, []), true);
    expect(eq(rc.payout, []), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC schaltet adminMode per direkter Wahl und per Toggle', () {
    final rc = IRegisterController();
    rc.adminMode(true);
    expect(rc.isAdminMode, true);
    rc.adminMode(false);
    expect(rc.isAdminMode, false);
    rc.adminMode();
    expect(rc.isAdminMode, true);
    rc.adminMode();
    expect(rc.isAdminMode, false);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC nimm im Admin-Mode Münzen an und erreicht Zielzustand', () {
    final rc = IRegisterController();
    rc.adminMode();
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.adminMode();
    expect(rc.displayDebit, 0);
    expect(rc.displayPrice, 0);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, null);
    expect(rc.selectedSlot, null);
    expect(eq(rc.coins, [100, 100, 10, 10, 10, 5, 5, 5, 5]), true);
    expect(eq(rc.payout, []), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC nimm im Admin-Mode Münzen an, aber lässt keine Produktwahl zu', () {
    final rc = IRegisterController();
    rc.adminMode();
    rc.insertCoin(10);
    rc.selectProduct(1, 30);
    rc.adminMode();
    expect(rc.displayDebit, 0);
    expect(rc.displayPrice, 0);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, null);
    expect(rc.selectedSlot, null);
    expect(eq(rc.coins, [10]), true);
    expect(eq(rc.payout, []), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC (ohne Admin) nimmt Bezahlung an', () {
    final rc = IRegisterController();
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(100);
    rc.insertCoin(100);
    expect(rc.displayDebit, 250);
    expect(rc.displayPrice, 0);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, null);
    expect(rc.selectedSlot, null);
    expect(eq(rc.coins, [100, 100, 10, 10, 10, 5, 5, 5, 5]), true);
    expect(eq(rc.payout, []), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC mit nicht ausreichender Bezahlung löst nix aus', () {
    final rc = IRegisterController();
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.selectProduct(1, 300);
    expect(rc.displayDebit, 250);
    expect(rc.displayPrice, 300);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, null);
    expect(rc.selectedSlot, 1);
    expect(eq(rc.coins, [100, 100, 10, 10, 10, 5, 5, 5, 5]), true);
    expect(eq(rc.payout, []), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC, nicht ausreichende Bezahlung, Auszahlung', () {
    final rc = IRegisterController();
    rc.adminMode();
    rc.insertCoin(50);
    rc.insertCoin(20);
    rc.insertCoin(100);
    rc.adminMode();
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(10);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(5);
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.selectProduct(1, 300);
    rc.reset();
    expect(rc.displayDebit, 0);
    expect(rc.displayPrice, 0);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, null);
    expect(rc.selectedSlot, null);
    expect(eq(rc.coins, [100, 20, 10, 10, 10, 5, 5, 5, 5]), true);
    expect(eq(rc.payout, [100, 100, 50]), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC, ausreichende Bezahlung, nachherige Wahl', () {
    final rc = IRegisterController();
    rc.adminMode();
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.insertCoin(50);
    rc.insertCoin(50);
    rc.insertCoin(20);
    rc.insertCoin(20);
    rc.adminMode();
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.selectProduct(1, 150);
    expect(rc.displayDebit, 0);
    expect(rc.displayPrice, 0);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, 1);
    expect(rc.selectedSlot, null);
    expect(eq(rc.coins, [100, 100, 100, 100, 50, 20, 20]), true);
    expect(eq(rc.payout, [50]), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC, ausreichende Bezahlung, vorherige Wahl', () {
    final rc = IRegisterController();
    rc.adminMode();
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.insertCoin(20);
    rc.insertCoin(50);
    rc.insertCoin(20);
    rc.insertCoin(20);
    rc.adminMode();
    rc.insertCoin(100);
    rc.selectProduct(1, 150);
    rc.insertCoin(100);
    expect(rc.displayDebit, 0);
    expect(rc.displayPrice, 0);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, 1);
    expect(rc.selectedSlot, null);
    print('${rc.coins}');
    print('${rc.payout}');
    expect(eq(rc.coins, [100, 100, 100, 100, 20, 20, 20]), true);
    expect(eq(rc.payout, [50]), true);
    expect(rc.message, 'Hallo Welt');
  });

  test('RC, ausreichende Bezahlung, aber Wechselgeld nicht möglich', () {
    final rc = IRegisterController();
    rc.adminMode();
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.adminMode();
    rc.insertCoin(100);
    rc.insertCoin(100);
    rc.selectProduct(1, 150);
    expect(rc.displayDebit, 200);
    expect(rc.displayPrice, 150);
    expect(rc.isAdminMode, false);
    expect(rc.producedSlot, null);
    expect(rc.selectedSlot, 1);
    print('${rc.coins}');
    print('${rc.payout}');
    expect(eq(rc.coins, [100, 100, 100, 100]), true);
    expect(eq(rc.payout, []), true);
    expect(rc.message, 'Bitte passend(er) bezahlen');
  });
}
