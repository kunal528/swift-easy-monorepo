import 'package:swift_ease/core/app_locator.dart';
import 'package:swift_ease/core/base_viewmodel.dart';
import 'package:swift_ease/core/model/user_model.dart';
import 'package:swift_ease/core/service/auth_service.dart';

class ApplicationViewModel extends BaseViewModel {
  late UserModel _user;

  UserModel get user => _user;

  final authService = locator<AuthService>();

  ApplicationViewModel() {
    getData();
  }

  void getData() async {
    setBusyAndNotify(true);
    // Simulate a network request
    await authService.getUserData().then((value) {
      _user = value;
      setBusyAndNotify(false);
    }).catchError((error) {
      setBusyAndNotify(false);
    });
  }
}
