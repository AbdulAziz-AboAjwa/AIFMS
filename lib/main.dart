import 'package:ai_financial_management_system/data_crud/data_crud.dart';
import 'package:ai_financial_management_system/presentation/pages/ai_chat_page.dart';
import 'package:ai_financial_management_system/presentation/pages/report_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'object_model/expense_type_adapter.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/main_nav_page.dart';

void main() async {
  await Future.value(dotenv.load(fileName: ".env"));
  Hive.registerAdapter(ExpenseTypeAdapter());
  await Hive.initFlutter();
  await Hive.openBox('monthly_payments');
  await Hive.openBox('subscriptions');
  await Hive.openBox('savings');
  await Hive.openBox('debts');
  await Hive.openBox('income');
  await Hive.openBox('username');
  await Hive.openBox('currency');
  await Hive.openBox('ai_chat_history');
  runApp(AifmsMain());
}

class AifmsMain extends StatelessWidget {
  const AifmsMain({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return DataCrud();
      },
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/home_main',
        routes: {
          '/home': (context) => HomePage(),
          '/report': (context) => ReportPage(),
          '/ai_chat': (context) => AiChatPage(),
          '/home_main': (context) => HomeMain(),
        },
      ),
    );
  }
}
