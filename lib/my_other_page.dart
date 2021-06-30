import 'package:flutter/material.dart';

class MyOtherPage extends StatelessWidget {
  final String param;

  const MyOtherPage({
    @required this.param,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other page'),
      ),
      body: Center(
        child: Text(
          param,
        ),
      ),
    );
  }
}
