class Expense {
  String id;
  String categoryId;
  String description;
  double amount;
  DateTime date;

  Expense({
    required this.id,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.date,
  });
}