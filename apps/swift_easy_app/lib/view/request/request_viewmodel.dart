import 'package:swift_ease/core/app_locator.dart';
import 'package:swift_ease/core/base_viewmodel.dart';
import 'package:swift_ease/core/model/request_model.dart';
import 'package:swift_ease/core/service/auth_service.dart';
import 'package:swift_ease/core/service/request_service.dart';

class RequestViewModel extends BaseViewModel {
  List<RequestModel> _requests = [];
  List<RequestModel> get requests => _requests;

  final authService = locator<AuthService>();
  final requestService = locator<RequestService>();

  RequestViewModel() {
    getData();
  }

  void getData() async {
    setBusyAndNotify(true);
    Future.wait([requestService.getRequests()])
        .then((value) => {_requests = value[0], setBusyAndNotify(false)});
  }
}
