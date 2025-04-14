import 'package:ai_financial_management_system/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../data_crud/data_crud.dart';
import '../components/cards/report_card.dart';
import '../components/doughnut_chart.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

final monthlyPayments = Hive.box('monthly_payments');
final subscriptions = Hive.box('subscriptions');
final savings = Hive.box('savings');
final debts = Hive.box('debts');
final incomeBox = Hive.box('income');
List<Box> boxes = [monthlyPayments, subscriptions, savings, debts];

List<String> boxNames = [
  'Monthly payments',
  'Subscriptions',
  'Savings',
  'Debts'
];

late double total;
late double income;
late double balance;
String currency = "";

class _ReportPageState extends State<ReportPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final dataCrudInstance = Provider.of<DataCrud>(context);
    total = dataCrudInstance.totalOfAllListed(boxes);
    income = dataCrudInstance.getIncome();
    balance = double.parse((income - total).toStringAsFixed(2));
    currency = dataCrudInstance.getCurrency();

    List<Color> colors = [
      powCyan, // monthly payments
      powYellow, // subscriptions
      powBrown, // savings
      powSage, // debts
    ];
    return Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
                  child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // chart
              DoughnutChart(),
        
              // expenses
              ...boxes.asMap().entries.map((entry) => Container(
                  margin: EdgeInsets.only(top: 15),
                  child: ReportCard(
                    boxName: entry.value,
                    expenseName: boxNames[entry.key],
                    color: colors[entry
                        .key], // Use entry.key to get corresponding color
                  ))),
              // Report summary
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: mainGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(top: 15, bottom: 15),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Summary",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    Divider(
                      color: Colors.white30,
                      height: 2,
                      thickness: 0.5,
                    ),
                    // income
                    Row(
                      children: [
                        Text('Income:', style: TextStyle(fontSize: 22)),
                        Spacer(),
                        Text('+$currency${income.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 22)),
                      ],
                    ),
                    // expenses
                    Row(
                      children: [
                        Text('Total expenses:',
                            style: TextStyle(fontSize: 22)),
                        Spacer(),
                        Text('-$currency${total.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 22)),
                      ],
                    ),
                    // balance
                    Row(
                      children: [
                        Text('Remaining balance:',
                            style: TextStyle(fontSize: 22)),
                        Spacer(),
                        Text('$currency${balance.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 22,
                                color: (balance < 0)
                                    ? Colors.redAccent
                                    : Colors.greenAccent)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
                  ),
                ),
    );
  }
}
