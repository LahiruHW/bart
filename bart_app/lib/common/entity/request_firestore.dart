import 'package:bart_app/common/typedefs/typedef_home_item.dart';

class RequestFirestore extends HomeItem {
  RequestFirestore({
    this.requestID = '',
    this.requestText = '',
    this.requestMadeBy = '',
  });

  final String requestID;
  final String requestText;
  final String requestMadeBy; // should be a UserLocalProfile

  factory RequestFirestore.fromMap(Map<String, dynamic> map) {
    return RequestFirestore(
      requestID: map['requestID'],
      requestText: map['requestText'],
      requestMadeBy: map['requestMadeBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestText': requestText,
      'requestMadeBy': requestMadeBy,
    };
  }
}
