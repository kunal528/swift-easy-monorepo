import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swift_ease/view/account/account_viewmodel.dart';

@RoutePage()
class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AccountViewModel(),
        builder: (context, _) {
          final model = context.watch<AccountViewModel>();

          if (model.busy) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title:
                  const Text('Account', style: TextStyle(color: Colors.black)),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Text(model.user.name[0],
                              style: Theme.of(context).textTheme.displayMedium),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          model.user.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@${model.user.username}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          model.user.email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          model.user.phone,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Menu Options
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.grey[700]),
                          title: const Text('Personal Info'),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey[700]),
                          onTap: () {},
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.receipt_long, color: Colors.grey[700]),
                          title: const Text('Transactions'),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey[700]),
                          onTap: () {
                            model.navigateToTransactions();
                          },
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.privacy_tip, color: Colors.grey[700]),
                          title: const Text('Privacy Policy'),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey[700]),
                          onTap: () {},
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.settings, color: Colors.grey[700]),
                          title: const Text('Settings'),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey[700]),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Logout',
                              style: TextStyle(color: Colors.red)),
                          onTap: () {
                            model.logout();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
