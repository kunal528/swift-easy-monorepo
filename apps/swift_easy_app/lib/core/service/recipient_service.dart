import 'package:swift_ease/core/app_locator.dart';
import 'package:swift_ease/core/model/user_model.dart';
import 'package:swift_ease/core/service/auth_service.dart';
import 'package:swift_ease/core/supabase.dart';

class RecipientService {
  static final String table = "users_v3";
  Future<List<UserModel>> getRecipients() async {
    final user = supabase.auth.currentUser;
    final response =
        await supabase.from(table).select().neq("email", user!.email!);
    return response.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<List<UserModel>> searchRecipients(String query) async {
    final user = await locator<AuthService>().getUserData();
    final response = await supabase
        .from(table)
        .select()
        .neq("email", user.email)
        .neq("country", user.country)
        .or('username.ilike.$query%,email.ilike.%$query%,name.ilike.%$query%');
    return response.map((e) => UserModel.fromMap(e)).toList();
  }
}
