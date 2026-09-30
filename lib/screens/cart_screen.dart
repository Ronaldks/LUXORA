import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../providers/shop_provider.dart';
import 'product_details_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = context.watch<ShopProvider>();

    final cartEntries = shopProvider.cart.entries.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'CART',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),

      body: cartEntries.isEmpty
          ? _buildEmptyCart()
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cartEntries.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 14);
              },
              itemBuilder: (context, index) {
                final entry = cartEntries[index];

                final Product? product =
                _findProduct(entry.key);

                if (product == null) {
                  return const SizedBox.shrink();
                }

                final quantity = entry.value;

                return _buildCartItem(
                  context,
                  product,
                  quantity,
                );
              },
            ),
          ),

          _buildOrderSummary(
            context,
            shopProvider,
          ),
        ],
      ),
    );
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

  // ============================================================
  // CART ITEM
  // ============================================================

  Widget _buildCartItem(
      BuildContext context,
      Product product,
      int quantity,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(
                  product: product,
                ),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            // ==================================================
            // IMAGE
            // ==================================================

            ClipRRect(
              borderRadius: BorderRadius.circular(14),

              child: SizedBox(
                width: 90,
                height: 110,

                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,

                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color: const Color(0xFFEDEBE6),

                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.black26,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ==================================================
            // PRODUCT DETAILS
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    product.category.toUpperCase(),

                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    '₹${product.price.toStringAsFixed(0)}',

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ============================================
                  // QUANTITY
                  // ============================================

                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          context
                              .read<ShopProvider>()
                              .decreaseQuantity(product);
                        },
                      ),

                      SizedBox(
                        width: 38,
                        child: Text(
                          quantity.toString(),
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      _buildQuantityButton(
                        icon: Icons.add,
                        onTap: () {
                          context
                              .read<ShopProvider>()
                              .increaseQuantity(product);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================================
            // DELETE
            // ==================================================

            IconButton(
              tooltip: 'Remove',

              onPressed: () {
                context
                    .read<ShopProvider>()
                    .removeFromCart(product);
              },

              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUANTITY BUTTON
  // ============================================================

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF1F0EC),
      borderRadius: BorderRadius.circular(9),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),

        child: SizedBox(
          width: 32,
          height: 32,

          child: Icon(
            icon,
            size: 17,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORDER SUMMARY
  // ============================================================

  Widget _buildOrderSummary(
      BuildContext context,
      ShopProvider shopProvider,
      ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),

      child: SafeArea(
        top: false,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Row(
              children: [
                Text(
                  'Items',

                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const Spacer(),

                Text(
                  shopProvider.cartItemCount.toString(),

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  'Total',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Text(
                  '₹${shopProvider.cartTotal.toStringAsFixed(0)}',

                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Going To Checkout!!!!',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF171717),

                  foregroundColor: Colors.white,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  'CHECKOUT',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY CART
  // ============================================================

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 90,
              height: 90,

              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 42,
                color: Colors.black38,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your Cart is Empty',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Add products you love and they will appear here.',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}