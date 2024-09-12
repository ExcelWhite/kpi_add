class Task {
  final String name;
  final int indicatorToMoId;
  final int parentId;
  final int order;

  Task({
    required this.name,
    required this.indicatorToMoId,
    required this.parentId,
    required this.order,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      indicatorToMoId: map['indicator_to_mo_id'],
      parentId: map['parent_id'],
      order: map['order'],
    );
  }

  // To update task properties, if necessary
  Task copyWith({
    String? name,
    int? indicatorToMoId,
    int? parentId,
    int? order,
  }) {
    return Task(
      name: name ?? this.name,
      indicatorToMoId: indicatorToMoId ?? this.indicatorToMoId,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
    );
  }
}
