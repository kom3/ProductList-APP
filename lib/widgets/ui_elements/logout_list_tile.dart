import 'package:first_app/scoped-models/main.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

class LogoutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          title: Text('Logout'),
          leading: Icon(Icons.exit_to_app),
          onTap: () {
            model.logout();
            Navigator.of(context).pushReplacementNamed('/');
          },
        );
      },
    );
  }
}