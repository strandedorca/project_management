enum PriorityLevel {
  non('0', 'No Priority'),
  low('1', 'Low Priority'),
  medium('2', 'Medium Priority'),
  high('3', 'High Priority');

  final String id;
  final String label;

  const PriorityLevel(this.id, this.label);
}
