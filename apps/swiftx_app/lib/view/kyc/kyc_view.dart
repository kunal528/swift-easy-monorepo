import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swift_ease/view/kyc/kyc_viewmodel.dart';
import 'package:swift_ease/widget/button/app_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class KycView extends StatelessWidget {
  final String country;
  const KycView({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => KycViewModel(),
        builder: (context, _) {
          final model = context.watch<KycViewModel>();
          return Scaffold(
              appBar: AppBar(),
              body: WebViewWidget(
                  controller: WebViewController()
                    ..loadRequest(Uri.parse("https://privy-webauth.vercel.app"))
                    ..clearCache()
                    ..clearLocalStorage()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..addJavaScriptChannel("FlutterChannel",
                        onMessageReceived: (message) {
                      if (message.message == 'closeWebView') {
                        model.submitKyc();
                      }
                    })));
        });
  }
}
