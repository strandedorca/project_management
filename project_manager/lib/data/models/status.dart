// Project/Task status enum
import 'package:project_manager/data/models/option.dart';

enum Status {
  onGoing('ongoing', 'Ongoing'),
  pending('pending', 'Pending'),
  completed('completed', 'Completed');

  final String value;
  final String label;

  const Status(this.value, this.label);

  /// Get all [Status] values as [Option]s for dropdowns and pickers.
  static List<Option> get getOptions =>
      values.map((e) => Option.fromValues(e.value, e.label, null)).toList();
}
