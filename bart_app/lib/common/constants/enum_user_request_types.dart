enum UserReqType {
  showMyData('showMyData');

  final String type;
  const UserReqType(this.type);

  @override
  toString() => type;

  static UserReqType fromString(String value) {
    switch (value) {
      case 'showMyData':
        return UserReqType.showMyData;
      default:
        throw Exception('UserReqType.fromString: Invalid value: $value');
    }
  }
}
