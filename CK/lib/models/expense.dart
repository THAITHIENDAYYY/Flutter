class Expense {
  final String id;
  final String title;
  final double amount;
  final String paidBy;
  final List<String> splitBetween;
  final DateTime date;
  final String groupId;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.splitBetween,
    required this.date,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'paidBy': paidBy,
      'splitBetween': splitBetween,
      'date': date.toIso8601String(),
      'groupId': groupId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'].toDouble(),
      paidBy: map['paidBy'],
      splitBetween: List<String>.from(map['splitBetween']),
      date: DateTime.parse(map['date']),
      groupId: map['groupId'],
    );
  }
} 