enum ItemType {
  object('object'),
  money('money');

  final String value;
  const ItemType(this.value);

  @override
  toString() => 'ItemType.$value';

  static ItemType fromString(String value) {
    switch (value) {
      case 'object':
        return ItemType.object;
      case 'money':
        return ItemType.money;
      default:
        throw Exception('ItemType.fromString: Invalid value: $value');
    }
  }
}
