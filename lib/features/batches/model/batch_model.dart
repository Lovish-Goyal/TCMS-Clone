class BatchModel {
  final String id;
  final String name;
  final String incharge;
  final String teacherId;
  final String location;

  BatchModel({
    required this.id,
    required this.name,
    required this.incharge,
    required this.teacherId,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'incharge': incharge,
      'teacherId': teacherId,
      'location': location,
    };
  }

  factory BatchModel.fromMap(Map<String, dynamic> map) {
    return BatchModel(
      id: map['id'],
      name: map['name'],
      incharge: map['incharge'],
      teacherId: map['teacherId'],
      location: map['location'],
    );
  }
}
