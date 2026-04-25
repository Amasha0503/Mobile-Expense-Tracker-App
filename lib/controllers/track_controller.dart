import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/models/category.dart';
import 'package:smart_expense_tracker/models/expense.dart';
import 'package:smart_expense_tracker/models/history.dart';
import 'package:smart_expense_tracker/models/income.dart';
import 'package:smart_expense_tracker/services/storage_service.dart';

class TrackController extends ChangeNotifier {
  TrackController() {
    loadStoredData();
  }

  final StorageService _storageService = StorageService();
  bool isLoading = true;

  List<Income> incomes = [];
  List<Expense> expenses = [];
  List<Category> categories = [];
  List<History> history = [];

  Future<void> loadStoredData() async {
    isLoading = true;
    notifyListeners();
    try {
      final stored = _storageService.loadAll();
      incomes = stored.incomes;
      expenses = stored.expenses;
      categories = stored.categories;
      history = stored.history;
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> _persistAll() async {
    await _storageService.saveAll(
      incomes: incomes,
      expenses: expenses,
      categories: categories,
      history: history,
    );
  }

  // ================= INCOME =================

  void addIncome(Income income) {
    incomes.add(income);
    _persistAll();
    notifyListeners();
  }

  void deleteIncome(String id) {
    incomes.removeWhere((i) => i.id == id);
    _persistAll();
    notifyListeners();
  }

  void updateIncome(Income updated) {
    final index = incomes.indexWhere((i) => i.id == updated.id);
    if (index == -1) return;
    incomes[index] = updated;
    _persistAll();
    notifyListeners();
  }

  double get totalIncome => incomes.fold(0, (sum, item) => sum + item.amount);

  // ================= EXPENSE =================

  void addExpense(Expense expense) {
    expenses.add(expense);
    _persistAll();
    notifyListeners();
  }

  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
    _persistAll();
    notifyListeners();
  }

  void updateExpense(Expense updated) {
    final index = expenses.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    expenses[index] = updated;
    _persistAll();
    notifyListeners();
  }

  double get totalExpense => expenses.fold(0, (sum, item) => sum + item.amount);

  // ================= CATEGORY =================

  void addCategory(Category category) {
    categories.add(category);
    _persistAll();
    notifyListeners();
  }

  void deleteCategory(String id) {
    categories.removeWhere((c) => c.id == id);
    expenses.removeWhere((e) => e.categoryId == id);
    _persistAll();
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

    _persistAll();
    notifyListeners();
  }
}
