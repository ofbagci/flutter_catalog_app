import 'package:flutter/material.dart';

import '../../core/models/product_model.dart';
import '../../core/services/product_service.dart';
import '../account/account_page.dart';
import 'widgets/banner_slider.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/product_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = const ProductService();
  late Future<List<Product>> _productsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts();
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_searchQuery.isEmpty) return products;
    final query = _searchQuery.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.tagline.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AccountPage()));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _productsFuture = _productService.fetchProducts();
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? [];
          final filteredProducts = _filterProducts(products);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HomeSearchBar(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SliverToBoxAdapter(child: BannerSlider()),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ProductGrid(products: filteredProducts),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),
    );
  }
}
