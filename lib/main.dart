import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<MyApp> {
  late WebViewController controller;
  String url = '';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadUrl();
  }

  _loadUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUrl = prefs.getString('webviewUrl');
    if (savedUrl == null || savedUrl.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Setting()),
      ).then((_) {
        _loadUrl();
      });
    } else {
      setState(() {
        url = savedUrl;
        controller.loadRequest(Uri.parse(url));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: url.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(
                controller: controller,
              ),
      ),
    );
  }
}
