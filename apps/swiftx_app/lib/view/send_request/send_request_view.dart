import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swift_ease/core/model/user_model.dart';
import 'package:swift_ease/view/send_request/send_request_viewmodel.dart';
import 'package:swift_ease/widget/button/app_button.dart';
import 'package:swift_ease/core/app_utils.dart';

@RoutePage()
class SendRequestView extends StatelessWidget {
  final bool isIncome;
  final UserModel recipient;
  final String countryCode;
  const SendRequestView(
      {super.key,
      required this.isIncome,
      required this.recipient,
      required this.countryCode});

  @override
  Widget build(BuildContext context) {
    final oppositeCountryCode = countryCode == "\$" ? "₹" : "\$";
    return ChangeNotifierProvider(
        create: (_) => SendRequestViewModel(countryCode, recipient),
        builder: (context, _) {
          final model = context.watch<SendRequestViewModel>();
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("You Have",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: model.userCurrencyController,
                              onChanged: (value) {
                                model.setAmount(value, countryCode);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Text(countryCode,
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                          "${countryCode}1 = ${countryCode == "\$" ? "₹${1.toDouble().toSGD()}" : "\$${1.toDouble().toAED()} "}",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Divider(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: model.recipientCurrencyController,
                                onChanged: (value) {
                                  model.setAmount(value, oppositeCountryCode);
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Text(countryCode == "\$" ? "₹" : "\$",
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                            "${oppositeCountryCode}1 = ${oppositeCountryCode == "\$" ? "₹${1.toDouble().toSGD()}" : "\$${1.toDouble().toAED()}"}",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppButton.primary(
                      title: isIncome ? "Request" : "Send",
                      onTap: () async {
                        try {
                          isIncome
                              ? await model.onRequest()
                              : await model.onSend();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}
