import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  String _selfSelectedProductId;
  User _authenticatedUser;
  bool _isLoading = false;
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

  String get selectedProductId {
    return _selfSelectedProductId;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  int get selectedProductIndex {
    return _products
        .indexWhere((Product product) => product.id == _selfSelectedProductId);
  }

  Product get selectedProoduct {
    if (_selfSelectedProductId == null) {
      return null;
    }

    return _products
        .firstWhere((Product product) => product.id == _selfSelectedProductId);
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://www.ikea.com/ca/en/images/products/choklad-ljus-milk-chocolate-bar__0446760_PE596815_S4.JPG',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response = await http.post(
          'https://flutter-products-first-app.firebaseio.com/products.json',
          body: json.encode(productData));

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
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://www.ikea.com/ca/en/images/products/choklad-ljus-milk-chocolate-bar__0446760_PE596815_S4.JPG',
      'price': price,
      'userEmail': selectedProoduct.userEmail,
      'userId': selectedProoduct.userId
    };
    return http
        .put(
            'https://flutter-products-first-app.firebaseio.com/products/${selectedProoduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;

      final Product updatedProduct = Product(
          id: selectedProoduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProoduct.userEmail,
          userId: selectedProoduct.userId);

      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final String deletedProductId = selectedProoduct.id;
    _products.removeAt(selectedProductIndex);
    _selfSelectedProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products-first-app.firebaseio.com/products/$deletedProductId.json')
        .then((http.Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutter-products-first-app.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      _isLoading = false;
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData != null) {
        productListData.forEach((String productId, dynamic productData) {
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
      }

      notifyListeners();
      _selfSelectedProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteState() {
    final bool currentFavorite = selectedProoduct.isFavorite;
    final bool newFavorite = !currentFavorite;
    final Product updatedProduct = Product(
        id: selectedProoduct.id,
        title: selectedProoduct.title,
        description: selectedProoduct.description,
        price: selectedProoduct.price,
        image: selectedProoduct.image,
        isFavorite: newFavorite,
        userEmail: selectedProoduct.userEmail,
        userId: selectedProoduct.userId);

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selfSelectedProductId = productId;
    if (_selfSelectedProductId != null) {
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

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
