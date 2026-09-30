import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/shop_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current wishlist state from Provider
    final shopProvider = context.watch<ShopProvider>();

    final bool isFavorite =
    shopProvider.isInWishlist(product);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildProductImage(
                context,
                isFavorite,
              ),
            ),

            SliverToBoxAdapter(
              child: _buildProductInformation(),
            ),
          ],
        ),
      ),

      bottomNavigationBar:
      _buildBottomBar(context),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _buildProductImage(
      BuildContext context,
      bool isFavorite,
      ) {
    return Stack(
      children: [
        Container(
          height: 420,
          width: double.infinity,
          color: const Color(0xFFEDEBE6),

          child: Image.network(
            product.image,
            fit: BoxFit.cover,

            loadingBuilder: (
                context,
                child,
                loadingProgress,
                ) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },

            errorBuilder: (
                context,
                error,
                stackTrace,
                ) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 60,
                  color: Colors.black26,
                ),
              );
            },
          ),
        ),

        // BACK BUTTON
        Positioned(
          top: 16,
          left: 16,
          child: _buildCircleButton(
            icon: Icons.arrow_back_rounded,

            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),

        // WISHLIST BUTTON
        Positioned(
          top: 16,
          right: 16,
          child: _buildCircleButton(
            icon: isFavorite
                ? Icons.favorite
                : Icons.favorite_border,

            iconColor: isFavorite
                ? Colors.red
                : Colors.black,

            onTap: () {
              context
                  .read<ShopProvider>()
                  .toggleWishlist(product);
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CIRCLE BUTTON
  // ============================================================

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,

      child: InkWell(
        customBorder: const CircleBorder(),

        onTap: onTap,

        child: SizedBox(
          width: 44,
          height: 44,

          child: Icon(
            icon,
            color: iconColor,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT INFORMATION
  // ============================================================

  Widget _buildProductInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        30,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(
            product.category.toUpperCase(),

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            product.name,

            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 14),

          // RATING
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),

                  borderRadius:
                  BorderRadius.circular(10),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 17,
                      color: Color(0xFFE8B44F),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      product.rating.toString(),

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'Highly rated',

                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // PRICE
          Text(
            '₹${product.price.toStringAsFixed(0)}',

            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            'Description',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.description,

            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 25),

          _buildInfoRow(
            Icons.category_outlined,
            'Category',
            product.category,
          ),

          const SizedBox(height: 14),

          _buildInfoRow(
            Icons.local_shipping_outlined,
            'Delivery',
            'Free delivery',
          ),

          const SizedBox(height: 14),

          _buildInfoRow(
            Icons.verified_outlined,
            'Quality',
            'Verified product',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION ROW
  // ============================================================

  Widget _buildInfoRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: Icon(
            icon,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Widget _buildBottomBar(
      BuildContext context,
      ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 54,

          child: ElevatedButton.icon(
            onPressed: () {
              // Add product to cart using Provider
              context
                  .read<ShopProvider>()
                  .addToCart(product);

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    '${product.name} added to cart',
                  ),

                  behavior:
                  SnackBarBehavior.floating,
                ),
              );
            },

            icon: const Icon(
              Icons.shopping_bag_outlined,
            ),

            label: const Text(
              'ADD TO CART',

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              const Color(0xFF171717),

              foregroundColor:
              Colors.white,

              elevation: 0,

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}