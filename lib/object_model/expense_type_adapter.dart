import 'package:hive_flutter/hive_flutter.dart';

import 'expense_object.dart';

// Required to use 'Expense' object with Hive
class ExpenseTypeAdapter extends TypeAdapter<Expense> {
  @override
  Expense read(BinaryReader reader) {
    return Expense(
        name: reader.readString(),
        details: reader.readString(),
        price: reader.readDouble(),
        index: reader.readInt(),
        );
        
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.details);
    writer.writeDouble(obj.price);
    writer.writeInt(obj.index);
  }
}