import 'package:swift_ease/core/app_locator.dart';
import 'package:swift_ease/core/model/transaction_model.dart';
import 'package:swift_ease/core/model/user_model.dart';
import 'package:swift_ease/core/service/auth_service.dart';
import 'package:swift_ease/core/supabase.dart';

class TransactionService {
  static final String table = "transactions_v3";

  static final String userTable = "users_v3";

  Future<void> createTransaction(UserModel recipient, double amount) async {
    try {
      final user = await locator<AuthService>().getUserData();
      final transaction = TransactionModel(
        id: 0,
        created_at: DateTime.now(),
        sender: user,
        receiver: recipient,
        amount: amount,
        status: "completed",
        sender_id: user.id,
        receiver_id: recipient.id,
      );
      await supabase.from(table).insert(transaction.toMap());
      await supabase.from(userTable).update({
        "balance": user.balance - amount,
      }).eq("id", user.id);
      await supabase.from(userTable).update({
        "balance": recipient.balance + amount,
      }).eq("id", recipient.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    try {
      final user = await locator<AuthService>().getUserData();
      final response = await supabase
          .from(table)
          .select("*, sender:sender_id(*), receiver:receiver_id(*)")
          .or("sender_id.eq.${user.id},receiver_id.eq.${user.id}")
          .order("created_at", ascending: false);
      return response.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> getRecentTransactions() async {
    try {
      final user = await locator<AuthService>().getUserData();
      final response = await supabase
          .from(table)
          .select("*, sender:sender_id(*), receiver:receiver_id(*)")
          .or("sender_id.eq.${user.id},receiver_id.eq.${user.id}")
          .order("created_at", ascending: false)
          .limit(5);
      return response.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
