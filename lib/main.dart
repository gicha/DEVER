import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";

String selectedUrl = "https://dever.itis.team/order/view/1";

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter WebView Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (_) => new MyHomePage(title: "Flutter WebView Demo"),
        "/widget": (_) =>
        new WebviewScaffold(
          url: selectedUrl,
        )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance of WebView plugin
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  TextEditingController _urlCtrl = new TextEditingController(text: selectedUrl);

  TextEditingController _codeCtrl =
  new TextEditingController(text: "window.navigator.userAgent");

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  final _history = [];

  @override
  initState() {
    super.initState();

    flutterWebviewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text("Webview Destroyed")));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add("onUrlChanged: $url");
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            setState(() {
              _history.add("onStateChanged: ${state.type} ${state.url}");
            });
          }
        });
    flutterWebviewPlugin.launch(selectedUrl);
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Plugin example app'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        ],
      ),
    );
  }
}


//var location = new Location();
//
//location.onLocationChanged.listen((
//Map<String, double> currentLocation) async {
//print(currentLocation["latitude"]);
//print(currentLocation["longitude"]);
//print(currentLocation["accuracy"]);
//print(currentLocation["altitude"]);
//
//var httpClient = new HttpClient();
//var data = JSON.encode(
//{
//"position": {
//"lon": currentLocation["longitude"].toString(),
//"lat": currentLocation["latitude"].toString()
//}
//}
//);
//var uri = new Uri.http(
//'dever.itis.team', '/order/set_state/1', {'data': data});
//var request = await httpClient.getUrl(uri);
//var response = await request.close();
//var responseBody = await response.transform(UTF8.decoder).join();
//print(responseBody);
//});