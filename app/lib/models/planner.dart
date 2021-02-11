import 'dart:ui';
import 'package:meta/meta.dart';

class Planner {
  final String id, uid, name;
  final bool archived, setup_done;

  Planner({
    required this.id,
    required this.uid,
    required this.name,
    this.archived = false,
    this.setup_done = false,
  });

  factory Planner.fromData(Map<String, dynamic> data) {
    return Planner(
      id: data['id'],
      uid: data['uid'],
      name: data['name'],
      archived: data['archived'],
      setup_done: data['setup_done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'archived': archived,
      'setup_done': setup_done,
      'deleted': false,
    };
  }

  Planner copyWith({String id, uid, name, bool archived, setup_done}) {
    return Planner(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      archived: archived ?? this.archived,
      setup_done: setup_done ?? this.setup_done,
    );
  }

  bool validate() {
    if (name == null || name == '') return false;
    if (id == null || id == '') return false;
    if (uid == null || uid == '') return false;
    if (archived == null) return false;
    if (setup_done == null) return false;
    return true;
  }

  @override
  bool operator ==(other) {
    return other is Planner &&
        (other.id == id &&
            other.name == name &&
            other.uid == uid &&
            other.archived == archived &&
            other.setup_done == setup_done);
  }

  @override
  int get hashCode {
    return hashList([
      id,
      uid,
      name,
      archived,
      setup_done,
    ]);
  }
}
