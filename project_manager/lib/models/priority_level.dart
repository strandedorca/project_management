enum PriorityLevel {
  no('0', 'No Priority'),
  low('1', 'Low'),
  medium('2', 'Medium'),
  high('3', 'High');

  final String id;
  final String label;

  const PriorityLevel(this.id, this.label);
}
