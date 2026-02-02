enum ImportanceMode {
  weight(1, 'Weight'),
  priority(2, 'Priority');

  final int id;
  final String label;

  const ImportanceMode(this.id, this.label);
}
