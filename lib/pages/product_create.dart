import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePage();
  }
}

class _ProductCreatePage extends State<ProductCreatePage> {
  String titleValue = '';
  String descriptionValue = '';
  double priceValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Product Title',
            ),
            onChanged: (String value) {
              setState(() {
                titleValue = value;
              });
            },
          ),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Product Description',
            ),
            onChanged: (String value) {
              setState(() {
                descriptionValue = value;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Product Price',
            ),
            onChanged: (String value) {
              setState(() {
                priceValue = double.parse(value);
              });
            },
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text('Save'),
            onPressed: () {
              final Map<String, dynamic> product = {
                'title': titleValue,
                'description': descriptionValue,
                'price': priceValue,
                'image': 'assets/food.jpg',
              };

              widget.addProduct(product);
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
    );
  }
}
