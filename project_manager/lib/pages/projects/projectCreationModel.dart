class ProjectCreationModel {
  ProjectCreationModel({
    this.name,
    this.description,
    this.categoryId,
    this.deadline,
    this.priority,
    this.status,
    // this.tags,
    // this.date,
    // this.reminders,
  });
  String? name;
  String? description;
  String? categoryId;
  DateTime? deadline;
  String? priority;
  String? status;
  // List<String>? tags;
  // final DateTime? date;
  // final List<String>? reminders;
}
