import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({ Key? key }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Builder(
            builder: ((BuildContext context) {
              return Stack(
                children: [
                  WebView(
                    initialUrl: "https://paystack.com/pay/2guwhhf8mo",
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController){
                      print("WebVeiw Set");
                      setState(() {
                        loading = true;
                      });
                      _controller.complete(webViewController);
                    },
                    onPageFinished: (page){
                      setState(() {
                        loading = false;
                      });
                    },
                    onProgress: (int progress) {
                      print("progress: $progress");
                    },
                    
                    javascriptChannels: <JavascriptChannel> {
                      _toasterJavascriptChannel(context)
                    },
                  ),

                  loading? const Center(
                    child:  SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()
                    ),
                  ): Container(),
                ],
              );

            }),
          )
        )
      )
    );
  }

  JavascriptChannel  _toasterJavascriptChannel(BuildContext context){ 
    return JavascriptChannel(
      name: "Toaster", 
      onMessageReceived: (JavascriptMessage message){
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message),)
        );
      }
    );
  }









}