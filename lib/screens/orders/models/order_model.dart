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
  User user;

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
    required this.user,
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
      latitudeBuyer: double.parse(json['latitude_buyer']),
      longitudeBuyer: double.parse(json['longitude_buyer']),
      userId: json['userID'],
      merchantId: json['merchantID'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      user: User.fromJson(json['User']),
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

class User {
  String name;

  User({
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
