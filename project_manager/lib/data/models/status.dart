// Project status enum
enum ProjectStatus {
  onGoing('ongoing', 'Ongoing'),
  notStarted('not_started', 'Not Started'),
  completed('completed', 'Completed');

  final String value;
  final String label;

  const ProjectStatus(this.value, this.label);
}
