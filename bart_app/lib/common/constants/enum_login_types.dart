
enum LoginType {
  google('google'),
  apple('apple');

  final String value;
  const LoginType(this.value);

  @override
  toString() => 'LoginType.$value';

  static LoginType fromString(String value) {
    switch (value) {
      case 'google':
        return LoginType.google;
      case 'apple':
        return LoginType.apple;
      default:
        throw Exception('LoginType.fromString: Invalid value: $value');
    }
  }
}
