import 'package:first_app/models/product.dart';
import 'package:first_app/scoped-models/connected_products.dart';

mixin ProductsModel on ConnectedProducts {

  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.of(products).where((Product p) => p.isFavorite).toList();
    }

    return List.from(products);
  }

  int get selectedProductIndex {
    return selfSelectedProductIndex;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Product get selectedProoduct {
    if (selfSelectedProductIndex == null) {
      return null;
    }

    return products[selfSelectedProductIndex];
  }

  void updateProduct(String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProoduct.userEmail,
        userId: selectedProoduct.userId);

    products[selfSelectedProductIndex] = updatedProduct;
    selfSelectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selfSelectedProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteState() {
    final bool currentFavorite = selectedProoduct.isFavorite;
    final bool newFavorite = !currentFavorite;
    final Product updatedProduct = Product(
        title: selectedProoduct.title,
        description: selectedProoduct.description,
        price: selectedProoduct.price,
        image: selectedProoduct.image,
        isFavorite: newFavorite,
        userEmail: selectedProoduct.userEmail,
        userId: selectedProoduct.userId);
    
    products[selfSelectedProductIndex] = updatedProduct;
    notifyListeners();
    selfSelectedProductIndex = null;
  }

  void selectProduct(int index) {
    selfSelectedProductIndex = index;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
