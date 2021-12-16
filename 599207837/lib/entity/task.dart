import 'dart:math';
import 'entities.dart';

class Task implements Message {
  @override
  Topic topic;

  String description;
  bool isCompleted = false;
  DateTime? timeCompleted;

  Task({required this.topic, required this.description});

  void complete() => isCompleted = true;

  void unComplete() => isCompleted = false;

  int get uuid => hashCode + Random.secure().nextInt(100);

  static List<Task> getPendingTasks() {
    var toReturn = <Task>[];
    toReturn.add(
      Task(
        description: 'Create flutter app',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    toReturn.add(
      Task(
        description: 'Start writing a term project',
        topic: Topic(name: 'BSUIR'),
      ),
    );
    toReturn.add(
      Task(
        description: 'See Arcane',
        topic: Topic(name: 'Leisure'),
      ),
    );
    return toReturn;
  }

  static List<Message> getPendingTasksM() {
    var toReturn = <Message>[];
    toReturn.add(
      Task(
        description: 'Create flutter app',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    toReturn.add(
      Task(
        description: 'Start writing a term project',
        topic: Topic(name: 'BSUIR'),
      ),
    );
    toReturn.add(
      Task(
        description: 'See Arcane',
        topic: Topic(name: 'Leisure'),
      ),
    );
    return toReturn;
  }
}
