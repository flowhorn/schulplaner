import 'package:app_functions/app_functions.dart';
import 'package:bloc/bloc_base.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

class SchulplanerFunctionsBloc extends BlocBase {
  final AppFunctionsBloc _appFunctionsBloc;

  const SchulplanerFunctionsBloc(this._appFunctionsBloc);
  @override
  void dispose() {}

  Future<AppFunctionsResult<bool>> joinGroup({
    required String myMemberId,
    required String groupId,
    required GroupType groupType,
  }) {
    return _appFunctionsBloc.callCloudFunction(
      functionName: 'JoinGroup',
      region: AppFunctionsRegions.europeWest3,
      parameters: {
        'myMemberId': myMemberId,
        'groupId': groupId,
        'groupType': groupType.toData(),
      },
    );
  }

  Future<AppFunctionsResult<bool>> leaveGroup({
    required String myMemberId,
    required String groupId,
    required GroupType groupType,
  }) {
    return _appFunctionsBloc.callCloudFunction(
      functionName: 'LeaveGroup',
      region: AppFunctionsRegions.europeWest3,
      parameters: {
        'myMemberId': myMemberId,
        'groupId': groupId,
        'groupType': groupType.toData(),
      },
    );
  }

  Future<AppFunctionsResult<bool>> removeMemberFromGroup({
    required String myMemberId,
    required String memberId,
    required String groupId,
    required GroupType groupType,
  }) {
    return _appFunctionsBloc.callCloudFunction(
      functionName: 'RemoveMemberFromGroup',
      region: AppFunctionsRegions.europeWest3,
      parameters: {
        'myMemberId': myMemberId,
        'memberId': memberId,
        'groupId': groupId,
        'groupType': groupType.toData(),
      },
    );
  }

  static SchulplanerFunctionsBloc of(BuildContext context) {
    return BlocProvider.of<SchulplanerFunctionsBloc>(context);
  }
}
