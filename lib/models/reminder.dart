class Reminder {
  final String task;
  final String description;
  final DateTime deadline;

  Reminder({
    this.task,
    this.description,
    this.deadline,
  });

  String get getName => task;
  String get getDescription => description;
  DateTime get getDeadline => deadline;

  Map<String, dynamic> toJson() {
    return {
      "name": this.task,
      "description": this.description,
      "deadline": this.deadline,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> parsedJson) {
    return Reminder(
      task: parsedJson['name'],
      description: parsedJson['description'],
      deadline: parsedJson['deadline'],
    );
  }
}
