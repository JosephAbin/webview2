import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String url = "";
  double progress = 0;
  InAppWebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('InAppWebView Example'),
        ),
        body: Container(
            child: Column(children: <Widget>[
             /* Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
              ),*/
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: Uri.parse("https://flutter.dev/")
                      ),
                      onWebViewCreated: (controller) {
                        webViewController = controller;

                      },

                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                          // urlController.text = this.url;
                          print('##___> onLoadStart');
                        });
                      },

                      onLoadStop: (controller, url) async {
                        // pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          //urlController.text = this.url;
                          print('##___> onLoadStop setState');
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        // pullToRefreshController.endRefreshing();
                        print('##___> onLoadError');
                      },

                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          // pullToRefreshController.endRefreshing();
                          print('##___> onProgressChanged');
                        }
                        setState(() {
                          this.progress = progress / 100;
                          // urlController.text = this.url;
                          print('##___> setState');
                        });

                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          // urlController.text = this.url;
                          print('##___> onUpdateVisitedHistory setState');
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },

                    ),
                ),
              ),

            ])),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await webViewController.canGoBack()) {
      controller.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Do you want to exit'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Yes'),
              ),
            ],
          ));
      return Future.value(true);
    }
}