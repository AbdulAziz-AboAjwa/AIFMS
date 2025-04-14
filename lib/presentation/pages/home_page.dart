import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../data_crud/data_crud.dart';

import '../../object_model/expense_object.dart';
import '../components/cards/expense_card.dart';
import '../components/colors.dart';
import '../components/expense_card_dialog_decoration.dart';
// import '../view_model/dialogs/update_income_dialog.dart';
import '../components/drawer/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final Box monthlyPayments = Hive.box('monthly_payments');
final Box subscriptions = Hive.box('subscriptions');
final Box savings = Hive.box('savings');
final Box debts = Hive.box('debts');
final Box incomeBox = Hive.box('income');
List<Box> boxes = [monthlyPayments, subscriptions, savings, debts];

Widget initWidget = Container();

bool monthlyBool = true;
bool subsBool = false;
bool savsBool = false;
bool debtsBool = false;

late double balance;
String currency = "";

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    setState(() {
      // setting 'debts' as the default box
      initWidget = ExpenseCard(boxName: monthlyPayments);
      monthlyBool = true;
      subsBool = false;
      savsBool = false;
      debtsBool = false;
    });
  }

  // to change where to add the new expense depending on the category the user in
  Box boxName = monthlyPayments;
  String boxNameString = "Monthly payment";

  @override
  Widget build(BuildContext context) {
    // controllers
    TextEditingController expenseName = TextEditingController();
    TextEditingController expenseDetails = TextEditingController();
    TextEditingController expensePrice = TextEditingController();
    // providers
    final dataCrudInstance = Provider.of<DataCrud>(context);
    balance = double.parse((dataCrudInstance.getIncome() - dataCrudInstance.totalOfAllListed(boxes)).toStringAsFixed(2));
    currency = dataCrudInstance.getCurrency();

    // add new expense dialog
    Widget addNewExpense = SingleChildScrollView(
      primary: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(spacing: 10, children: [
          // close dialog
          Text(
            "Add new $boxNameString",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: mainWhite),
          ),
          SizedBox(
            height: 10,
          ),
          // expense name
          TextField(
              textInputAction: TextInputAction.next,
              cursorColor: Colors.white70,
              controller: expenseName,
              maxLength: 15,
              decoration: expenseCardDecoration.copyWith(
                labelText: 'Title',
              )),
          // details
          TextField(
              textInputAction: TextInputAction.next,
              cursorColor: Colors.white70,
              controller: expenseDetails,
              maxLength: 30,
              decoration: expenseCardDecoration.copyWith(
                labelText: 'Description',
              )),
          // price
          TextField(
              textInputAction: TextInputAction.done,
              cursorColor: Colors.white70,
              controller: expensePrice,
              keyboardType: TextInputType.number,
              decoration: expenseCardDecoration.copyWith(
                labelText: 'Amount',
                prefixText: currency,
              )),
          SizedBox(
            height: 5,
          ),

          // submit
          ElevatedButton(
            onPressed: () {
              dataCrudInstance.addData(
                  boxName,
                  Expense(
                      name: (expenseName.text.isEmpty)
                          ? ""
                          : expenseName.text[0].toUpperCase() +
                              expenseName.text.substring(1),
                      details: (expenseDetails.text.isEmpty)
                          ? ""
                          : expenseDetails.text[0].toUpperCase() +
                              expenseDetails.text.substring(1),
                      price: (expensePrice.text.isEmpty)
                          ? 0
                          : double.parse(expensePrice.text),
                      index: boxName.length));
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(mainGreen),
              shadowColor: WidgetStatePropertyAll(Colors.transparent),
              overlayColor: WidgetStatePropertyAll(mainGreen),
            ),
            child: Text(
              "Add $boxNameString",
              style: TextStyle(
                  fontSize: 20,
                  color: mainWhite,
                  fontWeight: FontWeight.w400),
            ),
          )
        ]),
      ),
    );
    return Scaffold(
        drawer: CustomDrawer(),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(spacing: 10, children: [
              // balance
              SizedBox(
                width: double.infinity,
                // Total balance
                child: Container(
                  padding: EdgeInsets.fromLTRB(3, 10, 13, 10),
                  decoration: BoxDecoration(
                      color: mainGreen,
                      borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  height: 70,
                  // data row
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // drawer
                      Builder(
                        builder: (context) => IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(Icons.menu,
                                size: 25, color: Colors.white70),
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                shadowColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                padding:
                                    WidgetStatePropertyAll(EdgeInsets.all(3)))),
                      ),
                      // Total balance text
                      Text(
                        "Balance",
                        style: TextStyle(fontSize: 30, color: Color.fromARGB(218, 255, 255, 255)),
                      ),
                      Spacer(),
                      Text("$currency${balance.toStringAsFixed(0)}  ",
                          style: TextStyle(
                              fontSize: 30,
                              color:
                                  (balance < 0) ? Colors.red : Color.fromARGB(218, 255, 255, 255))),
                    ],
                  ),
                ),
              ),

              // categories
              SingleChildScrollView(
                primary: false,
                child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      spacing: 10,
                      children: [
                        // Monthly payments & subscriptions
                        Row(
                          spacing: 10,
                          children: [
                            // Monthly payments
                            Expanded(
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    monthlyBool = true;
                                    subsBool = false;
                                    savsBool = false;
                                    debtsBool = false;
                                    initWidget =
                                        ExpenseCard(boxName: monthlyPayments);
                                    boxName = monthlyPayments;
                                    boxNameString = "Monthly payment";
                                  });
                                },
                                contentPadding: EdgeInsets.all(1),
                                title: Text(
                                  'Monthly payments',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                                selected: monthlyBool,
                                selectedColor: secGreen,
                                selectedTileColor:
                                    secWhite,
                                textColor: secWhite,
                                tileColor: secGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            // Subscriptions
                            Expanded(
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    monthlyBool = false;
                                    subsBool = true;
                                    savsBool = false;
                                    debtsBool = false;
                                    initWidget =
                                        ExpenseCard(boxName: subscriptions);
                                    boxName = subscriptions;
                                    boxNameString = "Subscription";
                                  });
                                },
                                contentPadding: EdgeInsets.all(1),
                                title: Text(
                                  'Subscriptions',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                                selected: subsBool,
                                selectedColor: secGreen,
                                selectedTileColor:
                                    secWhite,
                                textColor: secWhite,
                                tileColor: secGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ],
                        ),
                        
                        
                        // Savings & Debts & add new expense button
                        Row(
                          spacing: 10,
                          children: [
                            // Savings
                            Expanded(
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    monthlyBool = false;
                                    subsBool = false;
                                    savsBool = true;
                                    debtsBool = false;
                                    initWidget = ExpenseCard(boxName: savings);
                                    boxName = savings;
                                    boxNameString = "Saving";
                                  });
                                },
                                contentPadding: EdgeInsets.all(1),
                                title: Text(
                                  'Savings',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                                selected: savsBool,
                                selectedColor: secGreen,
                                selectedTileColor:
                                    secWhite,
                                textColor: secWhite,
                                tileColor: secGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            // Debts
                            Expanded(
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    monthlyBool = false;
                                    subsBool = false;
                                    savsBool = false;
                                    debtsBool = true;
                                    initWidget = ExpenseCard(boxName: debts);
                                    boxName = debts;
                                    boxNameString = "Debt";
                                  });
                                },
                                contentPadding: EdgeInsets.all(1),
                                title: Text(
                                  'Debts',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                                selected: debtsBool,
                                selectedColor: secGreen,
                                selectedTileColor:
                                    secWhite,
                                textColor: secWhite,
                                tileColor: secGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            // Add new expense
                            FloatingActionButton(
                                backgroundColor: mainGreen,
                                onPressed: () {
                                    // details dialog
                                    showModalBottomSheet(
                                      showDragHandle: true,
                                      isScrollControlled: true,
                                      isDismissible: true,
                                      backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                      context: context,
                                      transitionAnimationController: AnimationController(
                                      vsync: this,
                                      duration: const Duration(milliseconds: 450),
                                      ),
                                      builder: (context) {
                                      return addNewExpense;
                                      });
                                },
                                child: Icon(
                                  Icons.add,
                                  color: secWhite,
                                )),
                          ],
                        ),
                      ],
                    )),
              ),

              // expenses cards
              Expanded(flex: 80, child: initWidget),
            ])));
  }
}
