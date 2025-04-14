import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../object_model/expense_object.dart';

class DataCrud extends ChangeNotifier {
  // Adds a new expense to the specified box
  addData(Box boxName, Expense expense) async {
    if (!boxName.isOpen) {
      boxName = await Hive.openBox(boxName.name);
    }
    boxName.add(expense);
    notifyListeners();
  }

  // Retrieves all data from the specified box
  getData(Box boxName) {
    List data = boxName.values.toList();
    return data;
  }

  // Updates an expense at specified index
  updateData(Box boxName, int index, Expense expense) {
    boxName.putAt(index, expense);
    notifyListeners();
  }

  // Deletes an expense at specified index
  deleteData(Box boxName, int index) {
    boxName.deleteAt(index);
    notifyListeners();
  }

  // Clears all data from specified box
  clearData(Box boxName) {
    boxName.clear();
    notifyListeners();
  }

  // Clears data from multiple boxes
  Future<void> clearAll(List<Box> boxes) async {
    for (var box in boxes) {
      await box.clear();
    }
    notifyListeners();
  }

  // Calculates total amount from one box
  totalOfOne(Box boxName) {
    double total = 0;
    List data = getData(boxName);
    for (var i = 0; i < data.length; i++) {
      total += data[i].price;
    }
    return total;
  }

  // Calculates total amount from multiple boxes
  totalOfAllListed(List<Box> boxes) {
    double total = 0;
    for (var box in boxes) {
      total += totalOfOne(box);
    }
    return total;
  }

  // Counts total number of expenses in a box
  totalExpenses(Box boxName) {
    List data = boxName.values.toList();
    return data.length;
  }

  // Saves income value
  addIncome(double income) {
    Hive.box('income').put(0, income);
    notifyListeners();
  }

  // Retrieves saved income value
  getIncome() {
    double income = Hive.box('income').get(0) ?? 0.0;
    return income;
  }

  // Updates currency symbol
  updateCurrency(String currency) {
    Hive.box('currency').put(0, currency);
    notifyListeners();
  }

  // Gets current currency symbol
  getCurrency() {
    String currency = Hive.box('currency').get(0) ?? "\$";
    return currency;
  }

  // Generates formatted summary of all expenses
  String getAllExpensesSummary() {
    final categories = {
      'Monthly Payments': 'monthly_payments',
      'Subscriptions': 'subscriptions',
      'Savings': 'savings',
      'Debts': 'debts',
    };

    Map<String, dynamic> allData = {
      ...categories
          .map((key, value) => MapEntry(key, getData(Hive.box(value)))),
      'Income': getIncome(),
    };

    final summary = allData.entries
        .where((entry) => entry.key != 'Income' && entry.value.isNotEmpty)
        .map((entry) {
      final sortedItems = List.from(entry.value)
        ..sort((a, b) => a.index.compareTo(b.index));
      return '''
📊 **${entry.key}**:
${sortedItems.map((expense) => '''- Name: ${expense.name}\n
  Details: ${expense.details}\n
  Price: ${getCurrency()}${expense.price.toStringAsFixed(2)}
''').join('\n')}''';
    }).join('\n');

    return '''
👤 ${getUserName()}'s Financial Summary

💰 Income: ${getCurrency()}${allData['Income'].toStringAsFixed(2)}

$summary''';
  }

  // Saves user name
  addUserName(String userName) {
    if (userName.isEmpty) {
      Hive.box('username').put(0, 'User');
    } else {
      Hive.box('username')
          .put(0, userName[0].toUpperCase() + userName.substring(1));
    }
    notifyListeners();
  }

  // Retrieves saved user name
  getUserName() {
    String userName = Hive.box('username').get(0) ?? "User";
    return userName;
  }
}
