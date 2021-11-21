class BonusePay {
  final String title;
  final String id;
  final String decription;
  final DateTime payDate;
  final double amount;
  const BonusePay({
    required this.amount,
    required this.title,
    required this.id,
    required this.decription,
    required this.payDate,
  });
}
