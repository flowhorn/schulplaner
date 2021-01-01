import 'package:meta/meta.dart';

import '../bloc/dynamic_link_bloc.dart';
import 'join_by_key.dart';
import 'personal_referral.dart';

class DynamicLinkData {
  final String id;
  final Uri link;
  final bool hasBeenHandled;

  DynamicLinkData(
      {@required this.id, @required this.link, this.hasBeenHandled = false});

  DynamicLinkData copyWith({bool hasBeenHandled}) {
    return DynamicLinkData(
      id: id,
      link: link,
      hasBeenHandled: hasBeenHandled ?? this.hasBeenHandled,
    );
  }

  Map<String, String> getValues() {
    return link?.queryParameters;
  }

  DynamicLinksType getType() {
    switch (getValues()['type']) {
      case referralPersonal:
        return DynamicLinksType.personalReferral;
      case joinByKey:
        return DynamicLinksType.joinByKey;
      default:
        return DynamicLinksType.unknown;
    }
  }

  DynamicLinkPersonalReferral getReferralData() {
    return DynamicLinkPersonalReferral(
      referredby: getValues()['referredby'],
    );
  }

  DynamicLinkJoinByKey getJoinByKeyData() {
    return DynamicLinkJoinByKey(
      publicKey: getValues()['data'],
    );
  }
}