import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String title, imageUrl;

  ProductPage(this.title, this.imageUrl);

  _showWarningDIalog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undine!'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  }),
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(imageUrl),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(title),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Delete'),
              onPressed: () => _showWarningDIalog(context),
            )
          ],
        ),
      ),
    );
  }
}
