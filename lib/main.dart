import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_link/my_other_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void _generateLink() async {
    final id = Random().nextInt(100);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://gabrielcarneiro.page.link',
      link: Uri.parse('https://gabrielcarneiro.com/share?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.gabrielcarneiro.demoapp',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Check out this product: (id) $id',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final dynamicUrl = await parameters.buildShortLink();

    await Share.share(dynamicUrl.shortUrl.toString());
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        final id = deepLink.queryParameters['id'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyOtherPage(param: id),
          ),
        );
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      final id = deepLink.queryParameters['id'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyOtherPage(param: id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Generate Link'),
          onPressed: _generateLink,
        ),
      ),
    );
  }
}
