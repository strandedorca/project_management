// Project status enum
enum ProjectStatus {
  onGoing('on_going', 'Ongoing'),
  notStarted('not_started', 'Not Started'),
  completed('completed', 'Completed');

  final String value;
  final String label;

  const ProjectStatus(this.value, this.label);
}
