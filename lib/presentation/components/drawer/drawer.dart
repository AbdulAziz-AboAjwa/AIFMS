import 'package:ai_financial_management_system/data_crud/data_crud.dart';
import 'package:ai_financial_management_system/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'components.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

bool sar = true;
bool usd = false;
final Box monthlyPayments = Hive.box('monthly_payments');
final Box subscriptions = Hive.box('subscriptions');
final Box savings = Hive.box('savings');
final Box debts = Hive.box('debts');
final Box incomeBox = Hive.box('income');
final Box userName = Hive.box('username');
final Box currencyBox = Hive.box('currency');
final Box aiChatHistory = Hive.box('ai_chat_history');
List<Box> boxes = [
  monthlyPayments,
  subscriptions,
  savings,
  debts,
  incomeBox,
  userName,
  currencyBox,
  aiChatHistory
];

class _CustomDrawerState extends State<CustomDrawer> {
  late TextEditingController incomeController;
  late TextEditingController userNameController;
  late double income;
  String currency = "";
  String userName = "";
  @override
  void initState() {
    super.initState();
    final dataCrudInstance = Provider.of<DataCrud>(context, listen: false);
    income = dataCrudInstance.getIncome();
    incomeController = TextEditingController(text: income.toString());
    userName = dataCrudInstance.getUserName();
    userNameController = TextEditingController(text: userName.toString());
  }

  @override
  void dispose() {
    incomeController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  String updateState = "Update income";
  @override
  Widget build(BuildContext context) {
    final dataCrudInstance = Provider.of<DataCrud>(context);
    currency = dataCrudInstance.getCurrency();
    income = dataCrudInstance.getIncome();
    userName = dataCrudInstance.getUserName();
    if (currency.contains("SR")) {
      sar = true;
      usd = false;
    } else if (currency.contains("\$")) {
      sar = false;
      usd = true;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Drawer(
        // coloring
        backgroundColor: secGreen,

        // setting the base for the work as responsive width and height with padding on all elements
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(20),
            child: Column(
              spacing: 10,
              children: [
                // Page title
                Text("Settings",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: mainWhite)),
                Divider(
                  color: Colors.white24,
                  thickness: 1,
                  height: 5,
                ),

                // Income
                Text("Income",
                    style: TextStyle(fontSize: 22, color: mainWhite)),
                // Income
                Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white10),
                  // Income data
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      // currency & textfield
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // currency
                          Text('$currency ',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white70,
                              )),
                          // textfield
                          SizedBox(
                            width: 185,
                            height: 55,
                            child: TextField(
                              onTap: () {
                                setState(() {
                                  updateState = "Update income";
                                });
                              },
                              controller: incomeController,
                              enableInteractiveSelection: false,
                              showCursor: true,
                              cursorHeight: 30,
                              cursorColor: Colors.white30,
                              cursorWidth: 1,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Update button
                      SizedBox(
                        height: 35,
                        child: TextButton(
                            onPressed: () {
                              // Dismiss keyboard
                              FocusScope.of(context).unfocus();

                              // constraints to avoid empty controller errors and no changes in the incme value
                              if (incomeController.text.isEmpty ||
                                  incomeController.text == income.toString()) {
                                setState(() {
                                  updateState = "Income updated!";
                                });
                              } else {
                                dataCrudInstance.addIncome(
                                    double.parse(incomeController.text));
                                setState(() {
                                  updateState = "Income updated!";
                                });
                              }
                            },
                            style: ButtonStyle(
                              // backgroundColor:
                              //     WidgetStatePropertyAll(mainGreen),
                              overlayColor: WidgetStatePropertyAll(mainGreen),
                            ),
                            child: Text(updateState,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: const Color.fromARGB(
                                        218, 255, 255, 255)))),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white12,
                  thickness: 1,
                  height: 5,
                ),

                // Username
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text("Name",
                        style: TextStyle(fontSize: 22, color: mainWhite)),
                    Container(
                      padding: EdgeInsets.all(12),
                      width: 180,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white10),
                      child: SizedBox(
                        height: 25,
                        child: TextField(
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            dataCrudInstance
                                .addUserName(userNameController.text);
                            setState(() {});
                          },
                          controller: userNameController,
                          enableInteractiveSelection: false,
                          showCursor: true,
                          cursorHeight: 20,
                          cursorColor: Colors.white30,
                          cursorWidth: 1,
                          textAlign: TextAlign.center,
                          maxLength: 12,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          buildCounter: (BuildContext context,
                              {required int currentLength,
                              required bool isFocused,
                              required int? maxLength}) {
                            return const SizedBox.shrink();
                          },
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              height: 1.8,
                              overflow: TextOverflow.ellipsis),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white12,
                  thickness: 1,
                  height: 5,
                ),

                // Currency
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      "Currency",
                      style: TextStyle(fontSize: 22, color: mainWhite),
                    ),
                    Spacer(),
                    // SAR
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: sar ? mainWhite : Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(8),
                        minimumSize: Size(35, 35),
                      ),
                      child: Text(
                        'SAR',
                        style: TextStyle(
                          fontSize: 12,
                          color: sar ? secGreen : mainWhite,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          dataCrudInstance.updateCurrency("SR ");
                        });
                      },
                    ),
                    // USD
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: usd ? mainWhite : Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(8),
                        minimumSize: Size(35, 35),
                      ),
                      child: Text(
                        'USD',
                        style: TextStyle(
                          fontSize: 12,
                          color: usd ? secGreen : mainWhite,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          dataCrudInstance.updateCurrency("\$");
                        });
                      },
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white12,
                  thickness: 1,
                  height: 5,
                ),

                // Clear all data
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      "Clear all data",
                      style: TextStyle(fontSize: 22, color: mainWhite),
                    ),
                    Spacer(),
                    // clear button
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color.fromARGB(255, 25, 23, 29),
                                  title: Text(
                                      "Are you sure you want to clear all data?"),
                                  actions: [
                                    TextButton(
                                      style: ButtonStyle(
                                          overlayColor: WidgetStatePropertyAll(
                                              Colors.white10)),
                                      onPressed: () {
                                        dataCrudInstance.clearAll(boxes);
                                        if (mounted) {
                                          setState(() {});
                                        }
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "Clear",
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
                        child: Text(
                          "Clear",
                          style: TextStyle(
                              color: const Color.fromARGB(141, 255, 83, 70)),
                        ))
                  ],
                ),
                Divider(
                  color: Colors.white24,
                  thickness: 1,
                  height: 5,
                ),

                // How to use
                ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  expansionAnimationStyle: AnimationStyle(
                    duration: Duration(milliseconds: 600),
                    reverseDuration: Duration(milliseconds: 600),
                    curve: Curves.decelerate,
                    reverseCurve: Curves.decelerate,
                  ),
                  iconColor: secWhite,
                  collapsedIconColor: secWhite,
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  title: Text("How to use?",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: mainWhite)),
                  children: [
                    howToUse,
                  ],
                ),
                Divider(
                  color: Colors.white24,
                  thickness: 1,
                  height: 5,
                ),

                // Privacy policy
                ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  expansionAnimationStyle: AnimationStyle(
                    duration: Duration(milliseconds: 600),
                    reverseDuration: Duration(milliseconds: 600),
                    curve: Curves.decelerate,
                    reverseCurve: Curves.decelerate,
                  ),
                  iconColor: secWhite,
                  collapsedIconColor: secWhite,
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  title: Text("Privacy policy",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: mainWhite)),
                  children: [
                    // policy script
                    privacyPolicy
                  ],
                ),
                Divider(
                  color: Colors.white24,
                  thickness: 1,
                  height: 5,
                ),

                // About us
                ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  expansionAnimationStyle: AnimationStyle(
                    duration: Duration(milliseconds: 600),
                    reverseDuration: Duration(milliseconds: 600),
                    curve: Curves.decelerate,
                    reverseCurve: Curves.decelerate,
                  ),
                  iconColor: secWhite,
                  collapsedIconColor: secWhite,
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  title: Text("About us",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: mainWhite)),
                  children: [
                    // about us script
                    aboutUs
                  ],
                ),
                Divider(
                  color: Colors.white24,
                  thickness: 1,
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
