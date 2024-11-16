import 'package:flutter/material.dart';
import 'package:swift_ease/core/app_locator.dart';
import 'package:swift_ease/core/app_router.dart';
import 'package:swift_ease/core/base_viewmodel.dart';
import 'package:swift_ease/core/model/user_model.dart';
import 'package:swift_ease/core/app_utils.dart';
import 'package:swift_ease/core/service/request_service.dart';
import 'package:swift_ease/core/service/transaction_service.dart';

class SendRequestViewModel extends BaseViewModel {
  String _amount = '0.00';
  String get amount => _amount;

  late UserModel _recipient;

  String _countryCode = "";

  String get recipientCountryCode => _countryCode == "\$" ? "₹" : "\$";

  TextEditingController userCurrencyController = TextEditingController();

  TextEditingController recipientCurrencyController = TextEditingController();
  final transactionService = locator<TransactionService>();
  final router = locator<AppRouter>();
  final requestService = locator<RequestService>();

  void setAmount(String value, String currency) {
    var usd = double.parse(value).toUSD(countryCode: currency);
    _amount = usd;
    if (currency == _countryCode) {
      recipientCurrencyController.text = currency == "\$"
          ? double.parse(value).toSGD()
          : double.parse(value).toAED();
    } else {
      userCurrencyController.text = currency == "\$"
          ? double.parse(value).toSGD()
          : double.parse(value).toAED();
    }
    notifyListeners();
  }

  SendRequestViewModel(this._countryCode, this._recipient);

  Future<void> onRequest() async {
    await requestService.createRequest(_recipient, double.parse(_amount));
    await router.maybePopTop();
    router.maybePopTop();
    // Send request to the recipient
  }

  Future<void> onSend() async {
    await transactionService
        .createTransaction(_recipient, double.parse(_amount))
        .then((value) async {
      await router.maybePopTop();
      router.maybePopTop();
    });
    // Send money to the recipient
  }
}
