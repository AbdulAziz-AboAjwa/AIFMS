import 'package:flutter/material.dart';
import '../colors.dart';

Widget howToUse = Column(
  spacing: 8,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // add new expense
    // headline
    Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Text(
        "Adding expenses",
        style: TextStyle(
            fontSize: 22, color: mainWhite, fontWeight: FontWeight.bold),
      ),
    ),
    // details
    Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Text(
        textAlign: TextAlign.justify,
        "To add a new expense, tap the + button located at home screen:",
        style: TextStyle(fontSize: 14, color: secWhite),
      ),
    ),
    // image
    ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset("assets/images/add_expense_button.jpg")),
    // details
    Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Text(
        textAlign: TextAlign.justify,
        "Tapping the + button opens a dialog where you can enter your expense details. The expense will be added to the current category once you confirm by pressing the button at the bottom:",
        style: TextStyle(fontSize: 14, color: secWhite),
      ),
    ),
    // image
    ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset("assets/images/add_expense_dialog.jpg")),
    // end of this part
    Divider(
      color: Colors.white12,
      thickness: 1,
      height: 10,
    ),

    // Edit expense
    // headline
    Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Text(
        "Editing expenses",
        style: TextStyle(
            fontSize: 22, color: mainWhite, fontWeight: FontWeight.bold),
      ),
    ),
    // details
    Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Text(
        textAlign: TextAlign.justify,
        "To edit an expense, simply tap on it to open an editing window. You can modify the expense details and save your changes by tapping 'Submit changes' at the bottom:",
        style: TextStyle(fontSize: 14, color: secWhite),
      ),
    ),
    // image
    ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset("assets/images/edit_expense_dialog.jpg")),
    // end of this part
    Divider(
      color: Colors.white12,
      thickness: 1,
      height: 10,
    ),

    // Delete expense
    // headline
    Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Text(
        "Deleting expenses",
        style: TextStyle(
            fontSize: 22, color: mainWhite, fontWeight: FontWeight.bold),
      ),
    ),
    // details
    Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Text(
        textAlign: TextAlign.justify,
        "To delete an expense, simply swipe the expense card from right to left. This action will remove the expense from your records:",
        style: TextStyle(fontSize: 14, color: secWhite),
      ),
    ),
    // image
    ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset("assets/images/delete_expense.jpg")),
  ],
);

Widget privacyPolicy = Container(
  padding: EdgeInsets.all(15),
  child: Text(
    textAlign: TextAlign.justify,
    "This app is designed for personal financial management and does not collect any personal data.\n\nAll your financial information is stored locally on your device using secure local storage (Hive).\n\nThe AI chat feature processes your inputs locally and does not store conversations on external servers.\n\nYou can delete all your data at any time using the 'Clear all data' option in settings.",
    style: TextStyle(fontSize: 16, color: mainWhite),
  ),
);

Widget aboutUs = Container(
    padding: EdgeInsets.all(15),
    child: Text(
      // textAlign: TextAlign.justify,
      "This app was developed as a graduation project for Arab Open University by three students:\n\nAbdulAziz Abo Ajwa - UI/UX Designer & Frontend Developer. \n\nHamza Abo Sharkh - Backend Developer & AI model designer.\n\nMamdouh Al Esawi - Data analyst.\n\nOur goal was to create a simple yet powerful financial management tool that helps users track their expenses while maintaining complete privacy and data security.",
      style: TextStyle(fontSize: 16, color: mainWhite),
    ));
