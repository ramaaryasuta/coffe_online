class Merchant {
  final int id;
  final int userID;
  final String name;
  final String phoneNumber;
  final String? avatar;
  final String longitude;
  final String latitude;
  final num distance;

  Merchant({
    required this.id,
    required this.userID,
    required this.name,
    required this.phoneNumber,
    this.avatar,
    required this.longitude,
    required this.latitude,
    required this.distance,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'],
      userID: json['userID'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      avatar: json['avatar'] ?? 'none',
      longitude: json['longitude'],
      latitude: json['latitude'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'name': name,
      'phone_number': phoneNumber,
      'avatar': avatar,
      'longitude': longitude,
      'latitude': latitude,
      'distance': distance,
    };
  }
}
