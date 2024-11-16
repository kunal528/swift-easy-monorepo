import 'package:swift_ease/core/app_locator.dart';
import 'package:swift_ease/core/base_viewmodel.dart';
import 'package:swift_ease/core/model/transaction_model.dart';
import 'package:swift_ease/core/service/auth_service.dart';
import 'package:swift_ease/core/service/transaction_service.dart';

class HomeViewModel extends BaseViewModel {
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  final authService = locator<AuthService>();
  final transactionService = locator<TransactionService>();

  HomeViewModel() {
    getData();
  }

  Future getData() async {
    setBusyAndNotify(true);
    Future.wait([transactionService.getRecentTransactions()]).then((value) {
      _transactions = value[0];
      setBusyAndNotify(false);
    }).catchError((error) {
      setBusyAndNotify(false);
    });
  }
}
