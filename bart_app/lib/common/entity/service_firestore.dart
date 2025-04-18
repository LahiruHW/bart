// import 'package:bart_app/common/typedefs/typedef_home_item.dart';

// class ServiceFirestore extends HomeItem {
class ServiceFirestore {
  ServiceFirestore({
    this.serviceID = '',
    this.offeredByUser = '',
  });

  final String serviceID;
  final String offeredByUser; // should be a UserLocalProfile

  factory ServiceFirestore.fromMap(Map<String, dynamic> map) {
    return ServiceFirestore(
      serviceID: map['id'],
      offeredByUser: map['offeredByUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offeredByUser': offeredByUser,
    };
  }
}
