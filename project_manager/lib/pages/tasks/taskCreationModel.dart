class TaskCreationModel {
  TaskCreationModel({
    this.name,
    this.description,
    this.projectId,
    this.deadline,
    this.priority,
    this.tags,
    // this.date,
    // this.reminders,
  });
  String? name;
  String? description;
  String? projectId;
  DateTime? deadline;
  String? priority;
  List<String>? tags;
  // final DateTime? date;
  // final List<String>? reminders;
}
