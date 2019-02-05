import 'package:first_app/models/user.dart';
import 'package:first_app/scoped-models/connected_products.dart';

mixin UserModel on ConnectedProducts {
  void login(String email, String password) {
    authenticatedUser = new User(id: '1', email: email, password: password);
  }
}
