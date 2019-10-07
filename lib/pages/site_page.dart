import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatefulWidget {
  @override
  _SitePageState createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  WebViewController controller;

  var _stackIds = 1;

  var _showProgress = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: _onClickRefresh,
          ),
        ],
      ),
      body: _webView2(),
    );
  }

  _webView() {
    return IndexedStack(
      index: _stackIds,
      children: <Widget>[
        WebView(
          initialUrl: "https://flutter.dev",
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
          onPageFinished: _onPageFinish,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (request) {
            print(request.url);

            return NavigationDecision.navigate;
          },
        ),
        Opacity(
          opacity: _showProgress ? 1 : 0,
          child: Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _webView2() {
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: "https://flutter.dev",
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
          onPageFinished: _onPageFinish,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (request) {
            print(request.url);

            return NavigationDecision.navigate;
          },
        ),
        Opacity(
          opacity: _showProgress ? 1 : 0,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _onClickRefresh() {
    this.controller.reload();
  }

  void _onPageFinish(String url) {
    setState(() {
      _showProgress = false;
      _stackIds = 0;
    });
  }
}
