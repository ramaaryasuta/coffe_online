class HistoryBuatUser {
  int id;
  int amount;
  String totalPrice;
  String address;
  String addressDetail;
  String latitudeBuyer;
  String longitudeBuyer;
  String doneAt;
  String status;
  int userID;
  int merchantID;
  String createdAt;
  String updatedAt;
  Merchant? merchant;
  User user;

  HistoryBuatUser({
    required this.id,
    required this.amount,
    required this.totalPrice,
    required this.address,
    required this.addressDetail,
    required this.latitudeBuyer,
    required this.longitudeBuyer,
    required this.doneAt,
    required this.status,
    required this.userID,
    required this.merchantID,
    required this.createdAt,
    required this.updatedAt,
    this.merchant,
    required this.user,
  });

  factory HistoryBuatUser.fromJson(Map<String, dynamic> json) {
    return HistoryBuatUser(
      id: json['id'],
      amount: json['amount'],
      totalPrice: json['totalPrice'],
      address: json['address'],
      addressDetail: json['address_detail'],
      latitudeBuyer: json['latitude_buyer'],
      longitudeBuyer: json['longitude_buyer'],
      doneAt: json['done_at'],
      status: json['status'],
      userID: json['userID'],
      merchantID: json['merchantID'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      merchant: Merchant.fromJson(json['Merchant']),
      user: User.fromJson(json['User']),
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
      'userID': userID,
      'merchantID': merchantID,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'Merchant': merchant?.toJson(),
      'User': user.toJson(),
    };
  }
}

class Merchant {
  int id;
  String latitude;
  String longitude;
  User user;

  Merchant({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.user,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      user: User.fromJson(json['User']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'User': user.toJson(),
    };
  }
}

class User {
  int id;
  String name;
  String email;
  String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
