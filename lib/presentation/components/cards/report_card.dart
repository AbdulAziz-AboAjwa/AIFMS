// import 'package:ai_financial_management_system/view_model/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../../data_crud/data_crud.dart';

// ignore: must_be_immutable
class ReportCard extends StatelessWidget {
  final Box boxName;
  final String expenseName;
  final Color color;

  ReportCard({
    super.key,
    required this.boxName,
    required this.expenseName,
    required this.color,
  });
  List data = [];
  String currency = "";

  @override
  Widget build(BuildContext context) {
    final dataCrudInstance = Provider.of<DataCrud>(context);
    data = dataCrudInstance.getData(boxName);
        currency = dataCrudInstance.getCurrency();

    // a text indicates that there is no expenses in this category
    Widget empty = Container(
      alignment: Alignment.center,
      child: Text(
          "You have no $expenseName \n You can add $expenseName in home page",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black45)),
    );
    // data
    return Container(
      height: data.length * 100.0 + 50,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: BoxConstraints(minHeight: 280, maxHeight: 500),
      child: Column(
        spacing: 10,
        children: [
          // name
          Text(expenseName,
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          // expenses list
          Expanded(
            child: (data.isEmpty)
                ? empty
                : ListView.separated(
                  primary: false,
                    itemCount: data.length,
                    separatorBuilder: (context, index) => Divider(
                          thickness: 0.5,
                          color: const Color.fromARGB(100, 255, 255, 255),
                        ),
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // name & details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  "${data[index].name}",
                                  style: TextStyle(fontSize: 25),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  " ${data[index].details}",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          // price
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              "$currency${data[index].price}",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 25),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      );
                    }),
          ),
          // total expenses
          Row(
            children: [
              Text(
                "Total $expenseName: $currency${dataCrudInstance.totalOfOne(boxName).toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
