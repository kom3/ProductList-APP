import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  int _selfSelectedProductIndex;

  User _authenticatedUser;

  void addProduct(
      String title, String description, String image, double price) {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://sallysbakingaddiction.com/wp-content/uploads/2017/06/chocolate-buttercream-recipe-2.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    http
        .post('https://flutter-products-first-app.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      notifyListeners();
    });
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.of(_products).where((Product p) => p.isFavorite).toList();
    }

    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selfSelectedProductIndex;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Product get selectedProoduct {
    if (_selfSelectedProductIndex == null) {
      return null;
    }

    return _products[_selfSelectedProductIndex];
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProoduct.userEmail,
        userId: selectedProoduct.userId);

    _products[_selfSelectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void fetchProducts() {
    http
        .get('https://flutter-products-first-app.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData =
          json.decode(response.body);
      productListData
          .forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);

        fetchedProductList.add(product);
      });

      _products = fetchedProductList;
      notifyListeners();
    });
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

    _products[_selfSelectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selfSelectedProductIndex = index;
    if (index != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = new User(id: '1', email: email, password: password);
  }
}
