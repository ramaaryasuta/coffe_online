class OrderResponse {
  String status;
  int id;
  int amount;
  String totalPrice;
  String address;
  String addressDetail;
  double latitudeBuyer;
  double longitudeBuyer;
  int userId;
  dynamic merchantId; // Use dynamic because it can be null
  DateTime updatedAt;
  DateTime createdAt;

  OrderResponse({
    required this.status,
    required this.id,
    required this.amount,
    required this.totalPrice,
    required this.address,
    required this.addressDetail,
    required this.latitudeBuyer,
    required this.longitudeBuyer,
    required this.userId,
    this.merchantId,
    required this.updatedAt,
    required this.createdAt,
  });

  // Parsing JSON to Dart object
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      status: json['status'],
      id: json['id'],
      amount: json['amount'],
      totalPrice: json['totalPrice'],
      address: json['address'],
      addressDetail: json['address_detail'],
      latitudeBuyer: json['latitude_buyer'].toDouble(),
      longitudeBuyer: json['longitude_buyer'].toDouble(),
      userId: json['userID'],
      merchantId: json['merchantID'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'amount': amount,
      'totalPrice': totalPrice,
      'address': address,
      'address_detail': addressDetail,
      'latitude_buyer': latitudeBuyer,
      'longitude_buyer': longitudeBuyer,
      'userID': userId,
      'merchantID': merchantId,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
