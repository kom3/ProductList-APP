import 'package:scoped_model/scoped_model.dart';

import 'package:first_app/scoped-models/connected_products.dart';

class MainModel extends Model with ConnectedProductsModel, UtilityModel, UserModel, ProductsModel {
  
}