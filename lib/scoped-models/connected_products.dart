import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';

import '../models/auth.dart';

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
          'https://flutter-products-first-app.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
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
            'https://flutter-products-first-app.firebaseio.com/products/${selectedProoduct.id}.json?auth=${_authenticatedUser.token}',
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
        .get(
            'https://flutter-products-first-app.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
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
  User get user {
    return _authenticatedUser;
  }
  
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    _isLoading = true;
    notifyListeners();
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBL3eIi-jWKupJW5tEWmxPHPKF6ZdgIGs8',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBL3eIi-jWKupJW5tEWmxPHPKF6ZdgIGs8',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', _authenticatedUser.token);
      prefs.setString('userEmail', _authenticatedUser.email);
      prefs.setString('userId', _authenticatedUser.id);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The Password is invalid.';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }

    print(responseData);

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void tokenAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      _authenticatedUser = User(
          id: userId,
          email: userEmail,
          token: token);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // await prefs.clear();
    await prefs.remove('token');
    await prefs.remove('userEmail');
    await prefs.remove('userId');
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
