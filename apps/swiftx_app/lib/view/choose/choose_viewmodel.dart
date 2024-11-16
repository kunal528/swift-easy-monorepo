import 'dart:async';

import 'package:swift_ease/core/app_locator.dart';
import 'package:swift_ease/core/app_router.dart';
import 'package:swift_ease/core/base_viewmodel.dart';
import 'package:swift_ease/core/model/user_model.dart';
import 'package:swift_ease/core/service/auth_service.dart';
import 'package:swift_ease/core/service/recipient_service.dart';

class ChooseViewModel extends BaseViewModel {
  String _query = '';
  String get query => _query;

  late UserModel _user;

  List<UserModel> _recipients = [];
  List<UserModel> get recipients => _recipients;

  Timer? _debounce;

  final recipientService = locator<RecipientService>();
  final authService = locator<AuthService>();
  final router = locator<AppRouter>();

  ChooseViewModel() {
    getData();
  }

  void getData() async {
    setBusyAndNotify(true);
    _user = await authService.getUserData();
    setBusyAndNotify(false);
  }

  void setQuery(String newQuery) {
    _query = newQuery;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      search(_query);
      notifyListeners();
    });
  }

  Future search(String query) async {
    setBusyAndNotify(true);
    final result = await recipientService.searchRecipients(query);
    _recipients = result;
    setBusyAndNotify(false);
  }

  void navigateToRecipient(UserModel recipient, bool isIncome) {
    router.push(SendRequestRoute(
        isIncome: isIncome,
        recipient: recipient,
        countryCode: _user.country == "US" ? "\$" : "₹"));
  }
}
