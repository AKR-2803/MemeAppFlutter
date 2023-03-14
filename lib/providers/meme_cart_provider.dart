import 'package:memeapp/models/cart_card_model.dart';
import 'package:flutter/cupertino.dart';

class MemeCartProvider extends ChangeNotifier {
  final List<CartCardModel> _cartList = <CartCardModel>[];
  List<String>? memesIdList = <String>[];

  List<CartCardModel> get getCartList => _cartList;
  List<String>? get getMemesIdList => memesIdList;

  void addItem(CartCardModel addThisItem) {
    _cartList.add(addThisItem);
    notifyListeners();
  }

  void removeItem(String memeId) {
    _cartList.removeWhere((element) => element.id == memeId);
    memesIdList!.remove(memeId);
    notifyListeners();
  }
}
