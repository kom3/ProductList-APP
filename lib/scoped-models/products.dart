import 'package:first_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;

  List<Product> get products {
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  Product get selectedProoduct {
    if (_selectedProductIndex == null) {
      return null;
    }

    return _products[_selectedProductIndex];
  }

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
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
        isFavorite: newFavorite);
    
    this.updateProduct(updatedProduct);
    notifyListeners();
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }
}
