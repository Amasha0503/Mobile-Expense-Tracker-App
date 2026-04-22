import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/models/category.dart';
import 'package:smart_expense_tracker/models/expense.dart';
import 'package:smart_expense_tracker/models/history.dart';
import 'package:smart_expense_tracker/models/income.dart';

class TrackController extends ChangeNotifier {
  List<Income> incomes = [];
  List<Expense> expenses = [];
  List<Category> categories = [];
  List<History> history = [];

  // ================= INCOME =================

  void addIncome(Income income) {
    incomes.add(income);
    notifyListeners();
  }

  void deleteIncome(String id) {
    incomes.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void updateIncome(Income updated) {
    int index = incomes.indexWhere((i) => i.id == updated.id);
    incomes[index] = updated;
    notifyListeners();
  }

  double get totalIncome => incomes.fold(0, (sum, item) => sum + item.amount);

  // ================= EXPENSE =================

  void addExpense(Expense expense) {
    expenses.add(expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  double get totalExpense => expenses.fold(0, (sum, item) => sum + item.amount);

  // ================= CATEGORY =================

  void addCategory(Category category) {
    categories.add(category);
    notifyListeners();
  }

  void deleteCategory(String id) {
    categories.removeWhere((c) => c.id == id);
    expenses.removeWhere((e) => e.categoryId == id);
    notifyListeners();
  }

  // ================= BALANCE =================

  double get balance => totalIncome - totalExpense;

  // ================= START NEW =================

  void startNewCycle() {
    if (incomes.isEmpty && expenses.isEmpty) return;

    history.add(
      History(
        date: DateTime.now(),
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        balance: balance,
      ),
    );

    incomes.clear();
    expenses.clear();
    categories.clear();

    //saveAll();
    notifyListeners();
  }
}
