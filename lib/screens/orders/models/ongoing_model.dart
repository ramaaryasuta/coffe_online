class OngoingResponse {
  int id;
  int amount;
  String totalPrice;
  String address;
  String addressDetail;
  double latitudeBuyer;
  double longitudeBuyer;
  String? doneAt;
  String status;
  int userId;
  int merchantId;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Merchant merchant;

  OngoingResponse({
    required this.id,
    required this.amount,
    required this.totalPrice,
    required this.address,
    required this.addressDetail,
    required this.latitudeBuyer,
    required this.longitudeBuyer,
    this.doneAt,
    required this.status,
    required this.userId,
    required this.merchantId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.merchant,
  });

  factory OngoingResponse.fromJson(Map<String, dynamic> json) {
    return OngoingResponse(
      id: json['id'],
      amount: json['amount'],
      totalPrice: json['totalPrice'],
      address: json['address'],
      addressDetail: json['address_detail'],
      latitudeBuyer: double.parse(json['latitude_buyer']),
      longitudeBuyer: double.parse(json['longitude_buyer']),
      doneAt: json['done_at'],
      status: json['status'],
      userId: json['userID'],
      merchantId: json['merchantID'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['User']),
      merchant: Merchant.fromJson(json['Merchant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'totalPrice': totalPrice,
      'address': address,
      'address_detail': addressDetail,
      'latitude_buyer': latitudeBuyer,
      'longitude_buyer': longitudeBuyer,
      'done_at': doneAt,
      'status': status,
      'userID': userId,
      'merchantID': merchantId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'User': user.toJson(),
      'Merchant': merchant.toJson(),
    };
  }
}

class User {
  int id;
  String token;
  String name;
  String phoneNumber;
  User({
    required this.id,
    required this.token,
    required this.name,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      token: json['token'],
      name: json['name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'name': name,
      'phone_number': phoneNumber,
    };
  }
}

class Merchant {
  int id;
  double latitude;
  double longitude;
  String? avatar;
  MerchantUser user;

  Merchant({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.avatar,
    required this.user,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      avatar: json['avatar'],
      user: MerchantUser.fromJson(json['User']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'avatar': avatar,
      'User': user.toJson(),
    };
  }
}

class MerchantUser {
  int id;
  String name;
  String email;
  String phoneNumber;

  MerchantUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory MerchantUser.fromJson(Map<String, dynamic> json) {
    return MerchantUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}
