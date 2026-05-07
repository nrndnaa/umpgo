class Payment {
  final int paymentID;
  final int feeID;
  final int studentID;
  final int amount;
  final String method;
  final String result;
  final int paidAt;

  Payment({
    required this.paymentID,
    required this.feeID,
    required this.studentID,
    required this.amount,
    required this.method,
    required this.result,
    required this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentID: json['paymentID'],
      feeID: json['feeID'],
      studentID: json['studentID'],
      amount: json['amount'],
      method: json['method'],
      result: json['result'],
      paidAt: json['paid_At'],
    );
  }
}
