import 'package:meta/meta.dart';
import 'package:schulplaner8/models/additionaltypes.dart';

@immutable
class UserProfile {
  final String uid, name, pic, picThumb, avatar;
  final ProfileDisplayMode displayMode;
  UserProfile._({
    @required this.name,
    @required this.pic,
    @required this.picThumb,
    @required this.uid,
    @required this.avatar,
    @required this.displayMode,
  });

  factory UserProfile.create({@required String uid}) {
    return UserProfile._(
      uid: uid,
      name: "",
      pic: null,
      picThumb: null,
      avatar: null,
      displayMode: ProfileDisplayMode.avatar,
    );
  }

  factory UserProfile.fromData(dynamic data) {
    return UserProfile._(
        uid: data['uid'],
        name: data['name'],
        pic: data['pic'],
        picThumb: data['picThumb'],
        avatar: data['avatar'],
        displayMode:
            profileDisplayModeEnumFromString(data['displayMode'] ?? 'none'));
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'pic': pic,
      'picThumb': picThumb,
      'avatar': avatar,
      'displayMode': profileDisplayModeEnumToString(displayMode),
    };
  }

  UserProfile copyWith({
    String uid,
    String name,
    String pic,
    String picThumb,
    String avatar,
    ProfileDisplayMode displayMode,
  }) {
    return UserProfile._(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      pic: pic ?? this.pic,
      picThumb: picThumb ?? this.picThumb,
      avatar: avatar ?? this.avatar,
      displayMode: displayMode ?? this.displayMode,
    );
  }

  UserProfile copyWithNoPic() {
    return UserProfile._(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      pic: null,
      picThumb: null,
      avatar: avatar ?? this.avatar,
      displayMode: displayMode ?? this.displayMode,
    );
  }

  bool validate() {
    if (name == null || name == "") return false;
    if (uid == null || uid == "") return false;
    return true;
  }

  @override
  String toString() {
    return 'UserProfile: ${toJson()}';
  }
}
