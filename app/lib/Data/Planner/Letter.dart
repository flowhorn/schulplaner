import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/utils/models/coder.dart';

enum ResponseType { NONE, DELIVERED, READ, REPLY }

class LetterResponse {
  final String id;
  final String? message;
  final ResponseType type;
  final Timestamp lastchanged;

  const LetterResponse._(
      {required this.id,
      required this.type,
      required this.message,
      required this.lastchanged});

  factory LetterResponse.Create({required String id}) {
    return LetterResponse._(
      id: id,
      type: ResponseType.NONE,
      message: null,
      lastchanged: Timestamp.now(),
    );
  }

  factory LetterResponse.FromData(dynamic data) {
    return LetterResponse._(
      id: data['id'],
      type: ResponseType.values[data['type']],
      message: data['message'],
      lastchanged: buildTimestamp(data['lastchanged']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type.index,
      'lastchanged': lastchanged,
    };
  }

  bool validate() {
    if (id == null) return false;
    if (type == null) return false;
    return true;
  }

  LetterResponse copyWith({
    String? id,
    String? message,
    ResponseType? type,
    Timestamp? lastchanged,
  }) {
    return LetterResponse._(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      lastchanged: lastchanged ?? this.lastchanged,
    );
  }

  String getUid() {
    return id.split('::')[0];
  }

  String getPlannerId() {
    return id.split('::')[1];
  }
}

class Letter {
  final String id, title, content;
  final String authorid;
  final SavedIn? savedin;
  final Timestamp published, lastchanged;
  final bool archived, deleted, sendpush, allowreply;
  final Map<String, CloudFile?> files;
  final Map<String, LetterResponse> responses;

  const Letter._(
      {required this.id,
      required this.title,
      required this.savedin,
      required this.content,
      required this.authorid,
      required this.published,
      required this.lastchanged,
      required this.archived,
      required this.deleted,
      required this.sendpush,
      required this.allowreply,
      required this.files,
      required this.responses});

  factory Letter.Create({required String id, required String authorid}) {
    return Letter._(
      id: id,
      title: '',
      content: '',
      authorid: authorid,
      published: Timestamp.now(),
      lastchanged: Timestamp.now(),
      archived: false,
      deleted: false,
      sendpush: false,
      allowreply: false,
      savedin: null,
      files: {},
      responses: {},
    );
  }

  factory Letter.FromData(dynamic data) {
    return Letter._(
        id: data['id'],
        title: data['title'],
        content: data['content'],
        authorid: data['authorid'],
        published: buildTimestamp(data['published']),
        lastchanged: buildTimestamp(data['lastchanged']),
        archived: data['archived'],
        deleted: data['deleted'],
        sendpush: data['sendpush'],
        allowreply: data['allowreply'],
        savedin: SavedIn.fromData(data['savedin']),
        files: decodeMap<CloudFile>(
          data['files'],
          (key, value) => CloudFile.fromData(value),
        ),
        responses: decodeMap<LetterResponse>(
            data['responses'], (key, value) => LetterResponse.FromData(value)));
  }

  Letter copyWith({
    String? id,
    title,
    content,
    String? authorid,
    SavedIn? savedin,
    Timestamp? published,
    lastchanged,
    bool? archived,
    deleted,
    sendpush,
    allowreply,
    Map<String, CloudFile?>? files,
    Map<String, LetterResponse>? responses,
  }) {
    return Letter._(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorid: authorid ?? this.authorid,
      savedin: savedin ?? this.savedin,
      published: published ?? this.published,
      lastchanged: lastchanged ?? this.lastchanged,
      archived: archived ?? this.archived,
      sendpush: sendpush ?? this.sendpush,
      allowreply: allowreply ?? this.allowreply,
      deleted: deleted ?? this.deleted,
      files: files ?? Map.of(this.files),
      responses: responses ?? Map.of(this.responses),
    );
  }

  Letter copyWithNull({
    SavedIn? savedin,
  }) {
    return Letter._(
      id: id,
      title: title,
      content: content,
      authorid: authorid,
      savedin: savedin,
      published: published,
      lastchanged: lastchanged,
      archived: archived,
      sendpush: sendpush,
      allowreply: allowreply,
      deleted: deleted,
      files: files,
      responses: responses,
    );
  }

  bool validate() {
    if (id == null || id == '') return false;
    if (title == null || title == '') return false;
    if (savedin == null) return false;
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'savedin': savedin?.toJson(),
      'published': published,
      'lastchanged': lastchanged,
      'archived': archived,
      'deleted': deleted,
      'sendpush': sendpush,
      'allowreply': allowreply,
      'files': files.map((key, value) => MapEntry(key, value?.toJson())),
      'responses': responses.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  bool isRead(PlannerDatabase database) {
    var response = responses[database.getMemberId()];
    if (response == null) return false;
    if (response.type == ResponseType.READ ||
        response.type == ResponseType.REPLY) {
      return true;
    } else {
      return false;
    }
  }

  LetterResponse? getMyResponse(PlannerDatabase database) {
    var response = responses[database.getMemberId()];
    return response;
  }
}
