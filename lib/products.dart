import 'package:flutter/material.dart';

// import './pages/product.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          // SizedBox(height: 10.0,),
          Container(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    products[index]['title'],
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    child: Text(
                      '\$' + products[index]['price'].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(6.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.5),
              child: Text('Surakarta, Central Java, Indonesia'),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.pushNamed(
                    context, '/product/' + index.toString()),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () => {

                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCard = Center(
      child: Text('No Product found, please add up!'),
    );

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] Build');

    return _buildProductList();
  }
}
