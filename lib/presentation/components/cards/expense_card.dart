import 'package:ai_financial_management_system/object_model/expense_object.dart';
import 'package:ai_financial_management_system/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../../data_crud/data_crud.dart';
// import '../../object_model/expense_object.dart';
import '../expense_card_dialog_decoration.dart';

// ignore: must_be_immutable
// This widget displays a list of expenses in a card format
// with support for editing and deleting expenses
class ExpenseCard extends StatefulWidget {
  final Box boxName;

  const ExpenseCard({
    super.key,
    required this.boxName,
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

// Stores currency symbol
String currency = "";

class _ExpenseCardState extends State<ExpenseCard>
    with TickerProviderStateMixin {
  // Stores expense data
  List data = [];

  @override
  Widget build(BuildContext context) {
    final dataCrudInstance = Provider.of<DataCrud>(context);
    data = dataCrudInstance.getData(widget.boxName);
    currency = dataCrudInstance.getCurrency();

    // Empty state widget
    Widget empty = Container(
      alignment: Alignment.center,
      child: Text("You have no expenses in this category",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white54)),
    );

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: (data.isEmpty)
                ? empty
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // Text controllers for editing expense
                      TextEditingController expenseName =
                          TextEditingController(text: data[index].name);
                      TextEditingController expenseDetails =
                          TextEditingController(text: data[index].details);
                      TextEditingController expensePrice =
                          TextEditingController(
                              text: data[index].price.toString());

                      // Swipeable expense card
                      return Dismissible(
                        resizeDuration: const Duration(milliseconds: 200),
                        direction: DismissDirection.endToStart,
                        key: ValueKey(data[index]),
                        confirmDismiss: (direction) async {
                          // Delete confirmation dialog
                          return await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      Text("Are you sure you want to delete?"),
                                  actions: [
                                    TextButton(
                                      style: ButtonStyle(
                                          overlayColor: WidgetStatePropertyAll(
                                              Colors.white10)),
                                      onPressed: () {
                                        dataCrudInstance.deleteData(
                                            widget.boxName, index);
                                        setState(() {
                                          data.removeAt(index);
                                        });
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                141, 255, 83, 70)),
                                      ),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          overlayColor: WidgetStatePropertyAll(
                                              Colors.white10)),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: secGreen),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        // Delete swipe background
                        background: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.delete_sweep_rounded,
                            color: const Color.fromARGB(141, 255, 83, 70),
                          ),
                        ),
                        child: GestureDetector(
                          // Edit expense bottom sheet
                          onTap: () {
                            showModalBottomSheet(
                                showDragHandle: true,
                                isScrollControlled: true,
                                isDismissible: true,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                transitionAnimationController:
                                    AnimationController(
                                  vsync: this,
                                  duration: const Duration(milliseconds: 450),
                                ),
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    child: Column(spacing: 10, children: [
                                      Text(
                                        "Edit expense",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: mainWhite),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Input fields for editing
                                      TextField(
                                          textInputAction: TextInputAction.next,
                                          cursorColor: mainWhite,
                                          controller: expenseName,
                                          maxLength: 15,
                                          decoration:
                                              expenseCardDecoration.copyWith(
                                            labelText: 'Title',
                                          )),
                                      TextField(
                                          textInputAction: TextInputAction.next,
                                          cursorColor: mainWhite,
                                          controller: expenseDetails,
                                          maxLength: 30,
                                          decoration:
                                              expenseCardDecoration.copyWith(
                                            labelText: 'Description',
                                          )),
                                      TextField(
                                          textInputAction: TextInputAction.done,
                                          cursorColor: mainWhite,
                                          controller: expensePrice,
                                          keyboardType: TextInputType.number,
                                          decoration:
                                              expenseCardDecoration.copyWith(
                                            labelText: 'Amount',
                                            prefixText: currency,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      // Submit button
                                      ElevatedButton(
                                        onPressed: () {
                                          dataCrudInstance.updateData(
                                              widget.boxName,
                                              index,
                                              Expense(
                                                  name: (expenseName
                                                          .text.isEmpty)
                                                      ? ""
                                                      : expenseName.text[0]
                                                              .toUpperCase() +
                                                          expenseName.text
                                                              .substring(1),
                                                  details: (expenseDetails
                                                          .text.isEmpty)
                                                      ? ""
                                                      : expenseDetails.text[0]
                                                              .toUpperCase() +
                                                          expenseDetails.text
                                                              .substring(1),
                                                  price: (expensePrice
                                                          .text.isEmpty)
                                                      ? 0
                                                      : double.parse(
                                                          expensePrice.text),
                                                  index: index));
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(mainGreen),
                                          shadowColor: WidgetStatePropertyAll(
                                              Colors.transparent),
                                          overlayColor:
                                              WidgetStatePropertyAll(mainGreen),
                                        ),
                                        child: Text(
                                          "Submit changes",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: mainWhite,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ]),
                                  );
                                });
                          },

                          // Expense card display
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.grey, width: 0.8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Expense name and details
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        "${data[index].name}",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: mainWhite,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        " ${data[index].details}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: const Color.fromARGB(
                                              180, 255, 255, 255),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                // Expense amount
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "$currency${data[index].price}",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 27,
                                      color: mainWhite,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
