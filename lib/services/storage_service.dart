import 'package:hive_flutter/hive_flutter.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../models/history.dart';
import '../models/income.dart';

class StoredData {
  final List<Income> incomes;
  final List<Expense> expenses;
  final List<Category> categories;
  final List<History> history;

  const StoredData({
    required this.incomes,
    required this.expenses,
    required this.categories,
    required this.history,
  });
}

class StorageService {
  static const String _boxName = 'trackwallet_box';
  static const String _incomesKey = 'incomes';
  static const String _expensesKey = 'expenses';
  static const String _categoriesKey = 'categories';
  static const String _historyKey = 'history';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  Box<dynamic> get _box => Hive.box(_boxName);

  Future<void> saveAll({
    required List<Income> incomes,
    required List<Expense> expenses,
    required List<Category> categories,
    required List<History> history,
  }) async {
    await _box.put(_incomesKey, incomes.map(_incomeToMap).toList());
    await _box.put(_expensesKey, expenses.map(_expenseToMap).toList());
    await _box.put(_categoriesKey, categories.map(_categoryToMap).toList());
    await _box.put(_historyKey, history.map(_historyToMap).toList());
  }

  StoredData loadAll() {
    final incomesRaw =(_box.get(_incomesKey, defaultValue: <dynamic>[]) as List).cast<dynamic>();
    final expensesRaw =(_box.get(_expensesKey, defaultValue: <dynamic>[]) as List).cast<dynamic>();
    final categoriesRaw =(_box.get(_categoriesKey, defaultValue: <dynamic>[]) as List).cast<dynamic>();
    final historyRaw =(_box.get(_historyKey, defaultValue: <dynamic>[]) as List).cast<dynamic>();

    return StoredData(
      incomes: incomesRaw.map((e) => _incomeFromMap(Map<String, dynamic>.from(e as Map))).toList(),
      expenses: expensesRaw.map((e) => _expenseFromMap(Map<String, dynamic>.from(e as Map))).toList(),
      categories: categoriesRaw.map((e) => _categoryFromMap(Map<String, dynamic>.from(e as Map))).toList(),
      history: historyRaw.map((e) => _historyFromMap(Map<String, dynamic>.from(e as Map))).toList(),
    );
  }

  Map<String, dynamic> _incomeToMap(Income income) {
    return {
      'id': income.id,
      'description': income.description,
      'amount': income.amount,
      'date': income.date.toIso8601String(),
    };
  }

  Income _incomeFromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] as String,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> _expenseToMap(Expense expense) {
    return {
      'id': expense.id,
      'categoryId': expense.categoryId,
      'description': expense.description,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
    };
  }

  Expense _expenseFromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      categoryId: map['categoryId'] as String,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> _categoryToMap(Category category) {
    return {'id': category.id, 'name': category.name};
  }

  Category _categoryFromMap(Map<String, dynamic> map) {
    return Category(id: map['id'] as String, name: map['name'] as String);
  }

  Map<String, dynamic> _historyToMap(History history) {
    return {
      'date': history.date.toIso8601String(),
      'totalIncome': history.totalIncome,
      'totalExpense': history.totalExpense,
      'balance': history.balance,
    };
  }

  History _historyFromMap(Map<String, dynamic> map) {
    return History(
      date: DateTime.parse(map['date'] as String),
      totalIncome: (map['totalIncome'] as num).toDouble(),
      totalExpense: (map['totalExpense'] as num).toDouble(),
      balance: (map['balance'] as num).toDouble(),
    );
  }
}
