
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/constants/enum_user_request_types.dart';

class UserRequest {
  UserRequest({
    required this.userID,
    required this.requestType,
    required this.timeCreated,
  });

  final String userID;
  final UserReqType requestType;
  final Timestamp timeCreated;

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      userID: json['userID'],
      requestType: UserReqType.fromString(json['requestType']),
      timeCreated: json['timeCreated'],
    );
  }

  Map<String, Object> toMap(){
    return {
      'userID': userID,
      'requestType': requestType.toString(),
      'timeCreated': timeCreated,
    };
  }

}
