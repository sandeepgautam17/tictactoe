
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/src/in_app_purchase/persistence/purchase_persistence.dart';

class LocalStoragePurchasePersistence extends PurchasePersistence {

  final keyCoinsCount = 'coinsCount';
  final Future<SharedPreferences> instanceFuture =
  SharedPreferences.getInstance();

  @override
  Future<int> getPurchaseCount() async {
    final prefs = await instanceFuture;
    return prefs.getInt(keyCoinsCount) ?? 50;
  }

  @override
  Future<void> setPurchaseCount(int count) async{
    final prefs = await instanceFuture;
    await prefs.setInt(keyCoinsCount, count);
  }

}