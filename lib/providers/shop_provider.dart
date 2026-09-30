import 'package:flutter/foundation.dart';

import '../data/products.dart';
import '../models/product.dart';

class ShopProvider extends ChangeNotifier {
  // ============================================================
  // WISHLIST
  // ============================================================

  final List<Product> _wishlist = [];

  List<Product> get wishlist {
    return List.unmodifiable(_wishlist);
  }

  bool isInWishlist(Product product) {
    return _wishlist.any(
          (item) => item.id == product.id,
    );
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      _wishlist.removeWhere(
            (item) => item.id == product.id,
      );
    } else {
      _wishlist.add(product);
    }

    notifyListeners();
  }

  // ============================================================
  // CART
  // ============================================================

  final Map<int, int> _cart = {};

  Map<int, int> get cart {
    return Map.unmodifiable(_cart);
  }

  // Total number of products in cart
  //
  // Example:
  // Shoes x2
  // Bag x1
  // Total = 3
  int get cartItemCount {
    return _cart.values.fold(
      0,
          (total, quantity) => total + quantity,
    );
  }

  // Get quantity of a particular product
  int quantityFor(Product product) {
    return _cart[product.id] ?? 0;
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  void addToCart(Product product) {
    _cart[product.id] =
        (_cart[product.id] ?? 0) + 1;

    notifyListeners();
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  void increaseQuantity(Product product) {
    _cart[product.id] =
        (_cart[product.id] ?? 0) + 1;

    notifyListeners();
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  void decreaseQuantity(Product product) {
    if (!_cart.containsKey(product.id)) {
      return;
    }

    final currentQuantity =
    _cart[product.id]!;

    if (currentQuantity > 1) {
      _cart[product.id] =
          currentQuantity - 1;
    } else {
      _cart.remove(product.id);
    }

    notifyListeners();
  }

  // ============================================================
  // REMOVE FROM CART
  // ============================================================

  void removeFromCart(Product product) {
    _cart.remove(product.id);

    notifyListeners();
  }

  // ============================================================
  // CART TOTAL
  // ============================================================

  double get cartTotal {
    double total = 0;

    for (final entry in _cart.entries) {
      final product = _findProduct(entry.key);

      if (product != null) {
        total += product.price * entry.value;
      }
    }

    return total;
  }

  // ============================================================
  // FIND PRODUCT
  // ============================================================

  Product? _findProduct(int id) {
    try {
      return products.firstWhere(
            (product) => product.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}