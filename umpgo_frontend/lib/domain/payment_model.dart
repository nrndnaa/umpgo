class Payment {
  final int paymentID;
  final int feeID;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final String paidAt;

  Payment({
    required this.paymentID,
    required this.feeID,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paidAt,
  });

  factory Payment.fromJson(
      Map<String, dynamic> json) {
    return Payment(
      paymentID: json['paymentID'],
      feeID: json['feeID'],
      amount: double.parse(
        json['amount'].toString(),
      ),
      paymentMethod:
          json['paymentMethod'] ?? '',
      paymentStatus:
          json['paymentStatus'] ?? '',
      paidAt:
          json['paid_at'] ?? '',
    );
  }
}