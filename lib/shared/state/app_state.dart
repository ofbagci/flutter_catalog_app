import 'package:flutter/material.dart';

import '../../core/models/product_model.dart';

class AppStateWidget extends StatefulWidget {
  final Widget child;

  const AppStateWidget({super.key, required this.child});

  @override
  State<AppStateWidget> createState() => _AppStateWidgetState();
}

class _AppStateWidgetState extends State<AppStateWidget> {
  final List<Product> _cartItems = [];
  final List<Product> _favoriteItems = [];

  List<Product> get cartItems => List.unmodifiable(_cartItems);
  List<Product> get favoriteItems => List.unmodifiable(_favoriteItems);

  void addToCart(Product product) {
    setState(() {
      if (!_cartItems.contains(product)) {
        _cartItems.add(product);
      }
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      _cartItems.remove(product);
    });
  }

  bool isInCart(Product product) {
    return _cartItems.contains(product);
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (_favoriteItems.contains(product)) {
        _favoriteItems.remove(product);
      } else {
        _favoriteItems.add(product);
      }
    });
  }

  bool isFavorite(Product product) {
    return _favoriteItems.contains(product);
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      cartItems: cartItems,
      favoriteItems: favoriteItems,
      addToCart: addToCart,
      removeFromCart: removeFromCart,
      isInCart: isInCart,
      toggleFavorite: toggleFavorite,
      isFavorite: isFavorite,
      child: widget.child,
    );
  }
}

class AppStateScope extends InheritedWidget {
  final List<Product> cartItems;
  final List<Product> favoriteItems;
  final void Function(Product) addToCart;
  final void Function(Product) removeFromCart;
  final bool Function(Product) isInCart;
  final void Function(Product) toggleFavorite;
  final bool Function(Product) isFavorite;

  const AppStateScope({
    super.key,
    required this.cartItems,
    required this.favoriteItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.isInCart,
    required this.toggleFavorite,
    required this.isFavorite,
    required super.child,
  });

  static AppStateScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return cartItems != oldWidget.cartItems ||
        favoriteItems != oldWidget.favoriteItems;
  }
}
