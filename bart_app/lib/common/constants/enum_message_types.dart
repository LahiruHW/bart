enum MessageType{
  text('text'),
  image('image'),
  video('video'),
  audio('audio'),
  sharedItem('sharedItem');

  final String value;
  const MessageType(this.value);

  @override
  toString() => 'MessageType.$value';

  static MessageType fromString(String value) {
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      case 'sharedItem':
        return MessageType.sharedItem;
      default:
        throw Exception('MessageType.fromString: Invalid value: $value');
    }
  }

}