import 'package:bart_app/common/entity/service_firestore.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

class Service {
  Service({
    required this.serviceID,
    required this.offeredByUser,
  });

  final String serviceID;
  final UserLocalProfile offeredByUser;

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceID: map['id'],
      offeredByUser: UserLocalProfile.fromMap(map['offeredByUser']),
    );
  }

  factory Service.fromFirestore(
    ServiceFirestore serviceFirestore,
    UserLocalProfile offeredByUser,
  ) {
    return Service(
      serviceID: serviceFirestore.serviceID,
      offeredByUser: offeredByUser,
    );
  }
}
