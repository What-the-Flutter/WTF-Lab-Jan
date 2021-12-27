import 'entities.dart' as entity;

class MessageLoader {

  static List<List<entity.Message>> messages = [];
  static List<List<entity.Message>> favouriteMessages = [];

  late int _lastChecked;
  late bool _forTopic;
  late final entity.Topic _topic;
  late final Type _type;

  MessageLoader(this._topic){
    _lastChecked=0;
    messages.add([]);
    _forTopic = true;
  }

  MessageLoader.type(this._type){
    _lastChecked=0;
    if(favouriteMessages.isEmpty){
      favouriteMessages.addAll([[],[],[]]);
    }
    _forTopic = false;
  }

  void loadMessages(int amount) {
    if(_forTopic){
      final requiredLength = messages[_topic.id].length + amount;
      while (messages[_topic.id].length < requiredLength) {
        _loadMessages4Topic();
      }
    }
  }

  void _loadMessages4Topic() {
    final fileLength = 10;
    for(var i = 0; i<fileLength; i++){
      messages[_topic.id].add(getHardcodeMessage(i, _topic.name));
    }
  }

  void loadTypeFavourites(){
    if(!_forTopic){}
  }

  static void addToFavourites(entity.Message o){
    favouriteMessages[entity.getTypeId(o)].insert(0, o);
  }

  static void removeFromFavourites(entity.Message o){
    favouriteMessages[entity.getTypeId(o)].remove(o);
  }

  static void remove(entity.Message o){
    favouriteMessages[entity.getTypeId(o)].remove(o);
    messages[o.topic.id].remove(o);
  }

  static entity.Message getHardcodeMessage(int index, String topicName) {
    if(entity.topics.isEmpty){
      entity.topics['WTF Lab'] = entity.Topic(name: 'WTF Lab');
      entity.topics['BSUIR'] = entity.Topic(name: 'BSUIR');
      entity.topics['Leisure'] = entity.Topic(name: 'Leisure');
    }

    switch (index % 3) {
      case (0):
        return entity.Task(
          description: 'HardcodedTask $index $topicName',
          topic: entity.topics[topicName]!,
        );
      case (1):
        return entity.Event(
          description: 'HardcodedEvent $index $topicName',
          topic: entity.topics[topicName]!,
        );
      default:
        return entity.Note(
          description: 'HardcodedEvent $index $topicName',
          topic: entity.topics[topicName]!,
        );
    }
  }
}
