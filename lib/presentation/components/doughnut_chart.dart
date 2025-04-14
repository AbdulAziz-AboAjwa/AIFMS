import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data_crud/data_crud.dart';
import 'colors.dart';

// ignore: must_be_immutable
class DoughnutChart extends StatelessWidget {
  DoughnutChart({super.key});

  final monthlyPayments = Hive.box('monthly_payments');
  final subscriptions = Hive.box('subscriptions');
  final savings = Hive.box('savings');
  final debts = Hive.box('debts');
  final incomeBox = Hive.box('income');
  late final List<Box> boxes;

  final List<String> boxNames = [
    'Monthly payments',
    'Subscriptions',
    'Savings',
    'Debts'
  ];

  late final double total;
  late final double income;
  late final double balance;
  String currency = "";

  @override
  Widget build(BuildContext context) {
    boxes = [monthlyPayments, subscriptions, savings, debts];
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
    return // charts
        Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
            height: 460,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 121, 121, 122)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Expenses chart",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                Divider(
                  color: Colors.white30,
                  thickness: 0.5,
                ),
                // doughnut chart
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Income: $currency${income.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(202, 255, 255, 255),
                      ),
                    ),
                    SfCircularChart(
                        palette: [
                          ...colors,
                          const Color.fromARGB(255, 103, 150, 105)
                        ],
                        legend: Legend(
                            isResponsive: true,
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                            orientation: LegendItemOrientation.auto,
                            itemPadding: 10),
                        annotations: [
                          CircularChartAnnotation(
                              widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Remaining',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              Text(
                                '$currency${balance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: balance < 0
                                      ? Colors.red[400]
                                      : Colors.green[300],
                                ),
                              ),
                            ],
                          ))
                        ],
                        series: <DoughnutSeries<dynamic, String>>[
                          DoughnutSeries<dynamic, String>(
                              radius: '70%',
                              innerRadius: '50%',
                              dataSource: [
                                ...boxes.asMap().entries.map((entry) {
                                  return {
                                    'category': boxNames[entry.key],
                                    'amount':
                                        dataCrudInstance.totalOfOne(entry.value)
                                  };
                                })
                              ],
                              xValueMapper: (data, _) => data['category'],
                              yValueMapper: (data, _) => data['amount'],
                              dataLabelMapper: (data, _) =>
                                  '$currency${data['amount'].toStringAsFixed(2)}',
                              dataLabelSettings: DataLabelSettings(
                                  margin: EdgeInsets.all(2),
                                  labelAlignment:
                                      ChartDataLabelAlignment.bottom,
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  labelIntersectAction:
                                      LabelIntersectAction.shift,
                                  connectorLineSettings: ConnectorLineSettings(
                                      type: ConnectorType.line)))
                        ]),
                  ],
                ),
              ],
            ));
  }
}
