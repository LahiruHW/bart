enum TradeCompType{
  incoming('incoming'),              // isAccepted = false and submitted to an item you posted on the market
  outgoing('outgoing'),              // isAccepted = false and submitted to an item you offered to someone else
  successful('successful'),          // isAccepted = true
  failed('failed'),  // isAccepted = false
  tradeHistory('tradeHistory'),      // isAccepted = true or false, but isRead = true
  none('none');                    // used for empty values

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
      case 'failed':
        return TradeCompType.failed;
      case 'tradeHistory':
        return TradeCompType.tradeHistory;
      case 'none':
        return TradeCompType.none;
      default:
        throw Exception('TradeCompletionType.fromString: Invalid value: $value');
    }
  }

}
