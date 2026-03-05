enum PriorityLevel {
  no('no_priority', 'No Priority'),
  low('low_priority', 'Low'),
  medium('medium_priority', 'Medium'),
  high('high_priority', 'High');

  final String value;
  final String label;

  const PriorityLevel(this.value, this.label);
}
