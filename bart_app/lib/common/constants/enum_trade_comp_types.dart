enum TradeCompType{
  incoming('incoming'),              // isAccepted = false and submitted to an item you posted on the market
  outgoing('outgoing'),              // isAccepted = false and submitted to an item you offered to someone else
  successful('successful'),          // isAccepted = true
  completeFailed('completeFailed'),  // isAccepted = false
  tradeHistory('tradeHistory'),      // isAccepted = true or false, but isRead = true
  empty('empty');                    // used for empty values

  final String value;
  const TradeCompType(this.value);

  @override
  toString() => 'TradeCompletionType.$value';

  static TradeCompType fromString(String value){
    switch(value){
      case 'incoming':
        return TradeCompType.incoming;
      case 'outgoing':
        return TradeCompType.outgoing;
      case 'successful':
        return TradeCompType.successful;
      case 'completeFailed':
        return TradeCompType.completeFailed;
      case 'tradeHistory':
        return TradeCompType.tradeHistory;
      case 'empty':
        return TradeCompType.empty;
      default:
        throw Exception('TradeCompletionType.fromString: Invalid value: $value');
    }
  }

}
