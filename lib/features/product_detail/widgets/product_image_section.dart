import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../../../shared/state/app_state.dart';

class ProductImageSection extends StatelessWidget {
  final Product product;

  const ProductImageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isFav = appState.isFavorite(product);

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Center(
                child: Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => appState.toggleFavorite(product),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
