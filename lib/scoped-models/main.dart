import 'package:scoped_model/scoped_model.dart';

import 'package:first_app/scoped-models/products.dart';
import 'package:first_app/scoped-models/user.dart';
import 'package:first_app/scoped-models/connected_products.dart';

class MainModel extends Model with ConnectedProducts, UserModel, ProductsModel {
  
}