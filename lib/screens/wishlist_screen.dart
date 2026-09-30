import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/shop_provider.dart';
import 'product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = context.watch<ShopProvider>();
    final wishlist = shopProvider.wishlist;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F4),
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'WISHLIST',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),

      body: wishlist.isEmpty
          ? _buildEmptyWishlist()
          : ListView.separated(
        padding: const EdgeInsets.all(20),

        itemCount: wishlist.length,

        separatorBuilder: (
            context,
            index,
            ) {
          return const SizedBox(height: 14);
        },

        itemBuilder: (
            context,
            index,
            ) {
          final product = wishlist[index];

          return _buildWishlistItem(
            context,
            product,
          );
        },
      ),
    );
  }

  // ============================================================
  // WISHLIST ITEM
  // ============================================================

  Widget _buildWishlistItem(
      BuildContext context,
      Product product,
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

          borderRadius:
          BorderRadius.circular(18),

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
            // PRODUCT IMAGE
            // ==================================================

            ClipRRect(
              borderRadius:
              BorderRadius.circular(14),

              child: SizedBox(
                width: 90,
                height: 100,

                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,

                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color:
                      const Color(0xFFEDEBE6),

                      child: const Icon(
                        Icons
                            .image_not_supported_outlined,
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
                      fontSize: 10,
                      fontWeight:
                      FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.name,

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '₹${product.price.toStringAsFixed(0)}',

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color:
                        Color(0xFFE8B44F),
                      ),

                      const SizedBox(width: 3),

                      Text(
                        product.rating.toString(),

                        style:
                        const TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================================
            // REMOVE BUTTON
            // ==================================================

            IconButton(
              onPressed: () {
                context
                    .read<ShopProvider>()
                    .toggleWishlist(product);
              },

              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY WISHLIST
  // ============================================================

  Widget _buildEmptyWishlist() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Container(
              width: 90,
              height: 90,

              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.favorite_border_rounded,
                size: 42,
                color: Colors.black38,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Save products you love and find them here later.',
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