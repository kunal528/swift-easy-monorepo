import 'package:get_it/get_it.dart';
import 'package:swift_ease/core/app_router.dart';
import 'package:swift_ease/core/service/auth_service.dart';
import 'package:swift_ease/core/service/recipient_service.dart';
import 'package:swift_ease/core/service/request_service.dart';
import 'package:swift_ease/core/service/transaction_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AppRouter>(AppRouter());
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<RecipientService>(RecipientService());
  locator.registerSingleton<TransactionService>(TransactionService());
  locator.registerSingleton<RequestService>(RequestService());
}
