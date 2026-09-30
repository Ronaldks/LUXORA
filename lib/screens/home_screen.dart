import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../providers/shop_provider.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final ScrollController _scrollController =
  ScrollController();

  // ============================================================
  // SEARCH / FILTER / SORT
  // ============================================================

  String selectedCategory = 'All';
  String searchQuery = '';
  String selectedSort = 'Default';

  // ============================================================
  // INFINITE SCROLL
  // ============================================================

  final List<Product> _loadedProducts = [];

  final int _productsPerPage = 6;

  int _currentPage = 0;

  bool _isLoadingMore = false;

  bool _hasMoreProducts = true;

  @override
  void initState() {
    super.initState();

    // Load the first batch
    _loadMoreProducts();

    // Listen for scrolling
    _scrollController.addListener(
      _onScroll,
    );
  }

  // ============================================================
  // LOAD MORE PRODUCTS
  // ============================================================

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate a small network/API delay.
    // In a real application this would be an API call.
    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    final int startIndex =
        _currentPage * _productsPerPage;

    final int endIndex =
        startIndex + _productsPerPage;

    if (startIndex >= products.length) {
      setState(() {
        _hasMoreProducts = false;
        _isLoadingMore = false;
      });

      return;
    }

    final int safeEndIndex =
    endIndex > products.length
        ? products.length
        : endIndex;

    final List<Product> nextProducts =
    products.sublist(
      startIndex,
      safeEndIndex,
    );

    setState(() {
      _loadedProducts.addAll(nextProducts);

      _currentPage++;

      _isLoadingMore = false;

      if (safeEndIndex >= products.length) {
        _hasMoreProducts = false;
      }
    });
  }

  // ============================================================
  // SCROLL LISTENER
  // ============================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position =
        _scrollController.position;

    // When the user is close to the bottom,
    // load the next batch.
    if (position.pixels >=
        position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        _hasMoreProducts) {
      _loadMoreProducts();
    }
  }

  // ============================================================
  // FILTER + SEARCH + SORT
  // ============================================================

  List<Product> get filteredProducts {
    List<Product> result =
    _loadedProducts.where((product) {
      final matchesSearch =
          product.name
              .toLowerCase()
              .contains(
            searchQuery.toLowerCase(),
          ) ||
              product.category
                  .toLowerCase()
                  .contains(
                searchQuery.toLowerCase(),
              );

      final matchesCategory =
          selectedCategory == 'All' ||
              product.category ==
                  selectedCategory;

      return matchesSearch &&
          matchesCategory;
    }).toList();

    // SORTING
    if (selectedSort ==
        'Price: Low to High') {
      result.sort(
            (a, b) =>
            a.price.compareTo(b.price),
      );
    } else if (selectedSort ==
        'Price: High to Low') {
      result.sort(
            (a, b) =>
            b.price.compareTo(a.price),
      );
    } else if (selectedSort == 'Rating') {
      result.sort(
            (a, b) =>
            b.rating.compareTo(a.rating),
      );
    }

    return result;
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  List<String> get categories {
    return [
      'All',
      'Shoes',
      'Bags',
      'Watches',
      'Clothing',
      'Beauty',
    ];
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _scrollController.removeListener(
      _onScroll,
    );

    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF8F7F4),

      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,

          slivers: [
            // ==================================================
            // HEADER
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  10,
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'LUXORA',

                            style: TextStyle(
                              fontSize: 26,
                              fontWeight:
                              FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            'Discover your style',

                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // WISHLIST
                    _buildTopIconButton(
                      icon:
                      Icons.favorite_border,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                            const WishlistScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    // CART
                    Consumer<ShopProvider>(
                      builder: (
                          context,
                          shopProvider,
                          child,
                          ) {
                        return Stack(
                          clipBehavior:
                          Clip.none,

                          children: [
                            _buildTopIconButton(
                              icon: Icons
                                  .shopping_bag_outlined,

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                    const CartScreen(),
                                  ),
                                );
                              },
                            ),

                            if (shopProvider
                                .cartItemCount >
                                0)
                              Positioned(
                                right: -5,
                                top: -5,

                                child:
                                Container(
                                  width: 21,
                                  height: 21,

                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Colors.red,
                                    shape:
                                    BoxShape
                                        .circle,
                                  ),

                                  alignment:
                                  Alignment
                                      .center,

                                  child: Text(
                                    shopProvider
                                        .cartItemCount
                                        .toString(),

                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // BANNER
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  15,
                  20,
                  20,
                ),

                child: Container(
                  height: 170,

                  decoration:
                  BoxDecoration(
                    color:
                    const Color(0xFF171717),

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),
                  ),

                  child: Stack(
                    children: [
                      Positioned(
                        left: 22,
                        top: 25,
                        right: 150,

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [
                            const Text(
                              'NEW SEASON',

                              style:
                              TextStyle(
                                color:
                                Colors.white70,
                                fontSize: 11,
                                letterSpacing:
                                2,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              'Elevate Your\nEveryday Style',

                              style:
                              TextStyle(
                                color:
                                Colors.white,
                                fontSize: 23,
                                height: 1.1,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              'Curated essentials for modern living',

                              style:
                              TextStyle(
                                color:
                                Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,

                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius
                              .only(
                            topRight:
                            Radius.circular(
                              24,
                            ),
                            bottomRight:
                            Radius.circular(
                              24,
                            ),
                          ),

                          child: SizedBox(
                            width: 145,

                            child:
                            Image.network(
                              'https://images.unsplash.com/photo-1445205170230-053b83016050',

                              fit: BoxFit.cover,

                              errorBuilder:
                                  (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Container(
                                  color: Colors
                                      .grey
                                      .shade800,

                                  child:
                                  const Icon(
                                    Icons.image,
                                    color:
                                    Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==================================================
            // SEARCH
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery =
                          value;
                    });
                  },

                  decoration:
                  InputDecoration(
                    hintText:
                    'Search products...',

                    prefixIcon:
                    const Icon(
                      Icons.search,
                    ),

                    filled: true,
                    fillColor:
                    Colors.white,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      BorderSide.none,
                    ),

                    enabledBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      BorderSide.none,
                    ),

                    focusedBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                      borderSide:
                      const BorderSide(
                        color:
                        Color(0xFF171717),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ==================================================
            // CATEGORY TITLE
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  25,
                  20,
                  10,
                ),

                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Categories',

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    TextButton.icon(
                      onPressed:
                      _showSortBottomSheet,

                      icon: const Icon(
                        Icons.sort,
                        size: 19,
                      ),

                      label:
                      const Text('Sort'),

                      style:
                      TextButton.styleFrom(
                        foregroundColor:
                        const Color(
                          0xFF171717,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // CATEGORIES
            // ==================================================

            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,

                child: ListView.separated(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  scrollDirection:
                  Axis.horizontal,

                  itemCount:
                  categories.length,

                  separatorBuilder:
                      (context, index) {
                    return const SizedBox(
                      width: 8,
                    );
                  },

                  itemBuilder:
                      (context, index) {
                    final category =
                    categories[index];

                    final isSelected =
                        selectedCategory ==
                            category;

                    return ChoiceChip(
                      label:
                      Text(category),

                      selected:
                      isSelected,

                      onSelected:
                          (selected) {
                        setState(() {
                          selectedCategory =
                              category;
                        });
                      },

                      selectedColor:
                      const Color(
                        0xFF171717,
                      ),

                      backgroundColor:
                      Colors.white,

                      labelStyle:
                      TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black,

                        fontWeight:
                        FontWeight.w600,
                      ),

                      side:
                      BorderSide.none,
                    );
                  },
                ),
              ),
            ),

            // ==================================================
            // PRODUCT COUNT
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  12,
                ),

                child: Text(
                  '${filteredProducts.length} Products',

                  style: TextStyle(
                    color:
                    Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),
            ),

            // ==================================================
            // PRODUCT GRID
            // ==================================================

            filteredProducts.isEmpty
                ? SliverToBoxAdapter(
              child:
              _buildEmptyState(),
            )
                : SliverPadding(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                20,
              ),

              sliver: SliverGrid(
                delegate:
                SliverChildBuilderDelegate(
                      (context, index) {
                    final product =
                    filteredProducts[
                    index];

                    return _buildProductCard(
                      product,
                    );
                  },

                  childCount:
                  filteredProducts
                      .length,
                ),

                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  MediaQuery.of(
                      context)
                      .size
                      .width >
                      800
                      ? 4
                      : MediaQuery.of(
                      context)
                      .size
                      .width >
                      550
                      ? 3
                      : 2,

                  crossAxisSpacing: 14,
                  mainAxisSpacing: 18,

                  childAspectRatio:
                  0.66,
                ),
              ),
            ),

            // ==================================================
            // LOADING INDICATOR
            // ==================================================

            SliverToBoxAdapter(
              child: _buildLoadingIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOADING INDICATOR
  // ============================================================

  Widget _buildLoadingIndicator() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 25,
        ),

        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 24,
                height: 24,

                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),

              SizedBox(height: 10),

              Text(
                'Loading more products...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasMoreProducts) {
      return Padding(
        padding:
        const EdgeInsets.symmetric(
          vertical: 25,
        ),

        child: Center(
          child: Text(
            'You\'ve reached the end',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    return const SizedBox(
      height: 20,
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _buildProductCard(
      Product product,
      ) {
    final shopProvider =
    context.watch<ShopProvider>();

    final bool isFavorite =
    shopProvider.isInWishlist(
      product,
    );

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
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // IMAGE
            Expanded(
              flex: 6,

              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius
                        .vertical(
                      top: Radius.circular(
                        18,
                      ),
                    ),

                    child: SizedBox(
                      width:
                      double.infinity,
                      height:
                      double.infinity,

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
                            const Color(
                              0xFFEDEBE6,
                            ),

                            child:
                            const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_outlined,
                                size: 40,
                                color:
                                Colors.black26,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // WISHLIST
                  Positioned(
                    top: 10,
                    right: 10,

                    child: Material(
                      color:
                      Colors.white,

                      shape:
                      const CircleBorder(),

                      elevation: 2,

                      child: InkWell(
                        customBorder:
                        const CircleBorder(),

                        onTap: () {
                          context
                              .read<
                              ShopProvider>()
                              .toggleWishlist(
                            product,
                          );
                        },

                        child: SizedBox(
                          width: 38,
                          height: 38,

                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons
                                .favorite_border,

                            color: isFavorite
                                ? Colors.red
                                : Colors.black,

                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PRODUCT INFO
            Expanded(
              flex: 4,

              child: Padding(
                padding:
                const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      product.category
                          .toUpperCase(),

                      style:
                      const TextStyle(
                        fontSize: 9,
                        fontWeight:
                        FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      product.name,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 15,
                          color:
                          Color(0xFFE8B44F),
                        ),

                        const SizedBox(
                          width: 3,
                        ),

                        Text(
                          product.rating
                              .toString(),

                          style:
                          const TextStyle(
                            fontSize: 11,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          '₹${product.price.toStringAsFixed(0)}',

                          style:
                          const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP ICON
  // ============================================================

  Widget _buildTopIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,

      shape:
      const CircleBorder(),

      elevation: 2,

      child: InkWell(
        customBorder:
        const CircleBorder(),

        onTap: onTap,

        child: SizedBox(
          width: 46,
          height: 46,

          child: Icon(
            icon,
            size: 22,
            color:
            const Color(0xFF171717),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 60,
      ),

      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,

            decoration:
            const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.search_off_rounded,
              size: 35,
              color: Colors.black38,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No products found',

            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Try changing your search or category.',

            textAlign:
            TextAlign.center,

            style: TextStyle(
              color:
              Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SORT
  // ============================================================

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,

      backgroundColor:
      Colors.white,

      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      builder: (context) {
        final options = [
          'Default',
          'Price: Low to High',
          'Price: High to Low',
          'Rating',
        ];

        return Padding(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),

          child: Column(
            mainAxisSize:
            MainAxisSize.min,

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              const Text(
                'Sort Products',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              ...options.map(
                    (option) {
                  final isSelected =
                      selectedSort ==
                          option;

                  return ListTile(
                    contentPadding:
                    EdgeInsets.zero,

                    title:
                    Text(option),

                    trailing:
                    isSelected
                        ? const Icon(
                      Icons.check,
                      color:
                      Color(
                        0xFF171717,
                      ),
                    )
                        : null,

                    onTap: () {
                      setState(() {
                        selectedSort =
                            option;
                      });

                      Navigator.pop(
                        context,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}