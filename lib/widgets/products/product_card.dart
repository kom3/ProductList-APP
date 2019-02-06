import 'package:first_app/models/product.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(product.price.toString())
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.pushNamed(
                context, '/product/' + model.allProducts[productIndex].id),
          ),
          IconButton(
            icon: Icon(model.allProducts[productIndex].isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.selectProduct(model.allProducts[productIndex].id);
              model.toggleProductFavoriteState();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/food.jpg'),
          ),
          // SizedBox(height: 10.0,),
          _buildTitlePriceRow(),
          AddressTag('Surakarta, Central Java, Indonesia'),
          Text(product.userEmail),
          _buildActionButton(context),
        ],
      ),
    );
  }
}
