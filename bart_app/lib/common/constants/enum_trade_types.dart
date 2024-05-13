enum TradeType {
  itemTrade('itemTrade'),
  moneyTrade('moneyTrade');

  final String value;
  const TradeType(this.value);

  @override
  toString() => 'TradeType.$value';

  static TradeType fromString(String value) {
    switch (value) {
      case 'itemTrade':
        return TradeType.itemTrade;
      case 'moneyTrade':
        return TradeType.moneyTrade;
      default:
        throw Exception('TradeType.fromString: Invalid value: $value');
    }
  }
}
