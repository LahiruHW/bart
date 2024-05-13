import 'package:bart_app/common/typedefs/typedef_home_item.dart';

class Request extends HomeItem {
  Request({
    this.requestID = '',
    this.requestText = '',
    this.requestMadeBy = '',
  });

  final String requestID;
  final String requestText;
  final String requestMadeBy; // should be a UserLocalProfile

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
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
