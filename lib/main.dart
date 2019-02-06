import 'package:first_app/models/product.dart';
import 'package:first_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/auth.dart';
import 'pages/products_admin.dart';
import 'pages/products.dart';
import 'pages/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.tokenAuthenticate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blueGrey,
          // primaryColor: Colors.white,
          accentColor: Colors.blueAccent,
          buttonColor: Colors.blueGrey,
        ),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => _model.user == null ? AuthPage() : ProductsPage(_model),
          '/products': (BuildContext context) => ProductsPage(_model),
          '/admin': (BuildContext context) => ProductsAdminPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product productSelected = _model.allProducts.firstWhere((Product product) => product.id == productId);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  ProductPage(productSelected),
            );
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_model));
        },
      ),
    );
  }
}
