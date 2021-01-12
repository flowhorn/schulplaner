// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../l10n/messages_all.dart';

class CupertinoEnDefaultLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoEnDefaultLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) => DefaultCupertinoLocalizations.load(Locale('en'));

  @override
  bool shouldReload(CupertinoEnDefaultLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultCupertinoLocalizations.delegate(en_US)';
}

class MyAppLocalizationsDelegate extends LocalizationsDelegate<MyAppLocalizations> {
  const MyAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<MyAppLocalizations> load(Locale locale) => MyAppLocalizations.load(locale);

  @override
  bool shouldReload(MyAppLocalizationsDelegate old) => false;
}

class MyAppLocalizations {
  String get languagecode {
    return Intl.message(
      'en',
      name: 'languagecode',
      desc: '_',
    );
  }

  String get informations {
    return Intl.message(
      'Informations',
      name: 'informations',
      desc: '_',
    );
  }

  String get lessons {
    return Intl.message(
      'Lessons',
      name: 'lessons',
      desc: '_',
    );
  }

  String get vacationdatabase {
    return Intl.message(
      'Vacationdatabase',
      name: 'vacationdatabase',
      desc: '_',
    );
  }

  String get lesson {
    return Intl.message(
      'Lesson',
      name: 'lesson',
      desc: '_',
    );
  }

  String get grades {
    return Intl.message(
      'Grades',
      name: 'grades',
      desc: '_',
    );
  }

  String get widgets {
    return Intl.message(
      'Widgets',
      name: 'widgets',
      desc: '_',
    );
  }

  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '_',
    );
  }

  String get discardchanges {
    return Intl.message(
      'Discard changes',
      name: 'discardchanges',
      desc: '_',
    );
  }

  String get currentchangesnotsaved {
    return Intl.message(
      'Current changes are not saved!',
      name: 'currentchangesnotsaved',
      desc: '_',
    );
  }

  String get timesoflessons {
    return Intl.message(
      'Times of lessons',
      name: 'timesoflessons',
      desc: '_',
    );
  }

  String get vacations {
    return Intl.message(
      'Vacations',
      name: 'vacations',
      desc: '_',
    );
  }

  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '_',
    );
  }

  String get until {
    return Intl.message(
      'Until',
      name: 'until',
      desc: '_',
    );
  }

  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '_',
    );
  }

  String get pleasewait {
    return Intl.message(
      'Please wait...',
      name: 'pleasewait',
      desc: '_',
    );
  }

  String get setstart {
    return Intl.message(
      'Set start',
      name: 'setstart',
      desc: '_',
    );
  }

  String get setend {
    return Intl.message(
      'Set end',
      name: 'setend',
      desc: '_',
    );
  }

  String get manageplanner {
    return Intl.message(
      'Manage planner',
      name: 'manageplanner',
      desc: '_',
    );
  }

  String get nothingselected {
    return Intl.message(
      'Nothing selected',
      name: 'nothingselected',
      desc: '_',
    );
  }

  String get colours {
    return Intl.message(
      'Colours',
      name: 'colours',
      desc: '_',
    );
  }

  String get primary {
    return Intl.message(
      'Primary',
      name: 'primary',
    );
  }

  String get accent {
    return Intl.message(
      'Accent',
      name: 'accent',
    );
  }

  String get darkmode {
    return Intl.message(
      'Darkmode',
      name: 'darkmode',
    );
  }

  String get automaticdarkmode {
    return Intl.message(
      'Automatic darkmode',
      name: 'automaticdarkmode',
      desc: '_',
    );
  }

  String get coloredappbar {
    return Intl.message(
      'Colored appbar',
      name: 'coloredappbar',
    );
  }

  String get weekend {
    return Intl.message(
      'Weekend',
      name: 'weekend',
    );
  }

  String get testsandexams {
    return Intl.message(
      'Tests and exams',
      name: 'testsandexams',
    );
  }

  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
    );
  }

  String get learnmore {
    return Intl.message(
      'Learn more',
      name: 'learnmore',
    );
  }

  String get selectmethode {
    return Intl.message(
      'Select method',
      name: 'selectmethode',
    );
  }

  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
    );
  }

  String get signinhasadvantages {
    return Intl.message(
      'Signing In has many advantages',
      name: 'signinhasadvantages',
      desc: '_',
    );
  }

  String get signinhasadvantages_desc {
    return Intl.message(
      'Synchronisation on multiple devices, share timetable and homework',
      name: 'signinhasadvantages_desc',
      desc: '_',
    );
  }

  String get noplannersavailable {
    return Intl.message(
      'No planners available',
      name: 'noplannersavailable',
    );
  }

  String get password {
    return Intl.message(
      'Password',
      name: 'password',
    );
  }

  String get selectplanner {
    return Intl.message(
      'Select planner',
      name: 'selectplanner',
    );
  }

  String get data {
    return Intl.message(
      'Data',
      name: 'data',
    );
  }

  String get newexam {
    return Intl.message(
      'New exam',
      name: 'newexam',
    );
  }

  String get all {
    return Intl.message(
      'All',
      name: 'all',
    );
  }

  String get in_ {
    return Intl.message(
      'in',
      name: 'in_',
    );
  }

  String get briefly {
    return Intl.message(
      'Briefly',
      name: 'briefly',
    );
  }

  String get noupcomingvacations {
    return Intl.message(
      'No upcoming vacations',
      name: 'noupcomingvacations',
    );
  }

  String get days {
    return Intl.message(
      'Days',
      name: 'days',
    );
  }

  String get periodoftime {
    return Intl.message(
      'Period of time',
      name: 'periodoftime',
    );
  }

  String get register {
    return Intl.message(
      'Register',
      name: 'register',
    );
  }

  String get signin {
    return Intl.message(
      'Sign In',
      name: 'signin',
    );
  }

  String get newvacation {
    return Intl.message(
      'New vacation',
      name: 'newvacation',
    );
  }

  String get editvacation {
    return Intl.message(
      'Edit vacation',
      name: 'editvacation',
    );
  }

  String get newplanner {
    return Intl.message(
      'New planner',
      name: 'newplanner',
    );
  }

  String get editplanner {
    return Intl.message(
      'Edit planner',
      name: 'editplanner',
    );
  }

  String get more {
    return Intl.message(
      'More',
      name: 'more',
    );
  }

  String get name {
    return Intl.message(
      'Name',
      name: 'name',
    );
  }

  String get nofavoritesselected {
    return Intl.message(
      'No favorites selected',
      name: 'nofavoritesselected',
    );
  }

  String get linkit {
    return Intl.message(
      'Link',
      name: 'linkit',
    );
  }

  String get linkemail {
    return Intl.message(
      'Link email',
      name: 'linkemail',
    );
  }

  String get pleasecheckdata {
    return Intl.message(
      'Please check data',
      name: 'pleasecheckdata',
    );
  }

  String get nextdays {
    return Intl.message(
      'Next days',
      name: 'nextdays',
    );
  }

  String get newtask {
    return Intl.message(
      'New task',
      name: 'newtask',
    );
  }

  String get newevent {
    return Intl.message(
      'New event',
      name: 'newevent',
    );
  }

  String get newgrade {
    return Intl.message(
      'New grade',
      name: 'newgrade',
    );
  }

  String get newnote {
    return Intl.message(
      'New note',
      name: 'newnote',
    );
  }

  String get newlessoninfo {
    return Intl.message(
      'New lessoninfo',
      name: 'newlessoninfo',
    );
  }

  String get newabsenttime {
    return Intl.message(
      'New absenttime',
      name: 'newabsenttime',
    );
  }

  String get edittask {
    return Intl.message(
      'Edit task',
      name: 'edittask',
    );
  }

  String get editevent {
    return Intl.message(
      'Edit tvent',
      name: 'editevent',
    );
  }

  String get editgrade {
    return Intl.message(
      'Edit grade',
      name: 'editgrade',
    );
  }

  String get editnote {
    return Intl.message(
      'Edit note',
      name: 'editnote',
    );
  }

  String get editlessoninfo {
    return Intl.message(
      'Edit lessoninfo',
      name: 'editlessoninfo',
    );
  }

  String get editabsenttime {
    return Intl.message(
      'Edit absenttime',
      name: 'editabsenttime',
    );
  }

  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
    );
  }

  String get notyetfinished {
    return Intl.message(
      'Not yet finished',
      name: 'notyetfinished',
    );
  }

  String get open {
    return Intl.message(
      'Open',
      name: 'open',
    );
  }

  String get due {
    return Intl.message(
      'Due',
      name: 'due',
    );
  }

  String get savein {
    return Intl.message(
      'Save in',
      name: 'savein',
    );
  }

  String get title {
    return Intl.message(
      'Title',
      name: 'title',
    );
  }

  String get course {
    return Intl.message(
      'Course',
      name: 'course',
    );
  }

  String get archive {
    return Intl.message(
      'Archive',
      name: 'archive',
    );
  }

  String get unarchive {
    return Intl.message(
      'Unarchive',
      name: 'unarchive',
    );
  }

  String get private {
    return Intl.message(
      'Private',
      name: 'private',
    );
  }

  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
    );
  }

  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
    );
  }

  String get detail {
    return Intl.message(
      'Detail',
      name: 'detail',
    );
  }

  String get date {
    return Intl.message(
      'Date',
      name: 'date',
    );
  }

  String get saveprivately {
    return Intl.message(
      'Save privately',
      name: 'saveprivately',
    );
  }

  String get weekday {
    return Intl.message(
      'Weekday',
      name: 'weekday',
    );
  }

  String get start {
    return Intl.message(
      'Start',
      name: 'start',
    );
  }

  String get end {
    return Intl.message(
      'End',
      name: 'end',
    );
  }

  String get weektype {
    return Intl.message(
      'Weektype',
      name: 'weektype',
    );
  }

  String get nolessoninfos {
    return Intl.message(
      'No lessoninfos',
      name: 'nolessoninfos',
    );
  }

  String get place {
    return Intl.message(
      'Place',
      name: 'place',
    );
  }

  String get teacher {
    return Intl.message(
      'Teacher',
      name: 'teacher',
    );
  }

  String get places {
    return Intl.message(
      'Places',
      name: 'places',
    );
  }

  String get teachers {
    return Intl.message(
      'Teachers',
      name: 'teachers',
    );
  }

  String get export {
    return Intl.message(
      'Export',
      name: 'export',
    );
  }

  String get schoolclass {
    return Intl.message(
      'Schoolclass',
      name: 'schoolclass',
    );
  }

  String get allfunctions {
    return Intl.message(
      'All functions',
      name: 'allfunctions',
    );
  }

  String get allevents {
    return Intl.message(
      'All events',
      name: 'allevents',
    );
  }

  String get exams {
    return Intl.message(
      'Exams',
      name: 'exams',
    );
  }

  String get addons {
    return Intl.message(
      'Addons',
      name: 'addons',
    );
  }

  String get join {
    return Intl.message(
      'Join',
      name: 'join',
    );
  }

  String get create {
    return Intl.message(
      'Create',
      name: 'create',
    );
  }

  String get schoolreports {
    return Intl.message(
      'Schoolreports',
      name: 'schoolreports',
    );
  }

  String get indays {
    return Intl.message(
      'days',
      name: 'indays',
    );
  }

  String get individual {
    return Intl.message(
      'Individual',
      name: 'individual',
    );
  }

  String get overritetimes {
    return Intl.message(
      'Override times',
      name: 'overritetimes',
    );
  }

  String get defaultused {
    return Intl.message(
      'Default used',
      name: 'defaultused',
    );
  }

  String get nextlesson {
    return Intl.message(
      'Next lesson',
      name: 'nextlesson',
    );
  }

  String get amountoflessons {
    return Intl.message(
      'Amount of lessons',
      name: 'amountoflessons',
    );
  }

  String get absentlessons {
    return Intl.message(
      'Absent times',
      name: 'absentlessons',
    );
  }

  String get unexcused {
    return Intl.message(
      'Without excuse',
      name: 'unexcused',
    );
  }

  String get excused {
    return Intl.message(
      'excused',
      name: 'excused',
    );
  }

  String get today {
    return Intl.message(
      'Today',
      name: 'today',
    );
  }

  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
    );
  }

  String get profilepicture {
    return Intl.message(
      'Avatar',
      name: 'profilepicture',
    );
  }

  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
    );
  }

  String get editlesson {
    return Intl.message(
      'Edit lesson',
      name: 'editlesson',
    );
  }

  String get editprofile {
    return Intl.message(
      'Edit profile',
      name: 'editprofile',
    );
  }

  String get newlesson {
    return Intl.message(
      'New lesson',
      name: 'newlesson',
    );
  }

  String get type {
    return Intl.message(
      'Type',
      name: 'type',
    );
  }

  String get schoolreport {
    return Intl.message(
      'Schoolreport',
      name: 'schoolreport',
    );
  }

  String get newschoolreport {
    return Intl.message(
      'New schoolreport',
      name: 'newschoolreport',
    );
  }

  String get editschoolreport {
    return Intl.message(
      'Edit schoolreport',
      name: 'editschoolreport',
    );
  }

  String get oralexam {
    return Intl.message(
      'Oral exam',
      name: 'oralexam',
    );
  }

  String get generalparticipation {
    return Intl.message(
      'General participation',
      name: 'generalparticipation',
    );
  }

  String get other {
    return Intl.message(
      'Other',
      name: 'other',
    );
  }

  String get addcoursein {
    return Intl.message(
      'Add course in',
      name: 'addcoursein',
    );
  }

  String get addcourse {
    return Intl.message(
      'Add course',
      name: 'addcourse',
    );
  }

  String get newschoolclass {
    return Intl.message(
      'New schoolclass',
      name: 'newschoolclass',
    );
  }

  String get editschoolclass {
    return Intl.message(
      'Edit schoolclass',
      name: 'editschoolclass',
    );
  }

  String get timetoremember {
    return Intl.message(
      'Time to remember',
      name: 'timetoremember',
    );
  }

  String get assistnotifications {
    return Intl.message(
      'Assist-Notifications',
      name: 'assistnotifications',
    );
  }

  String get createnotifications {
    return Intl.message(
      'Create-Notifications',
      name: 'createnotifications',
    );
  }

  String get dailynotifications {
    return Intl.message(
      'Daily-Notifications',
      name: 'dailynotifications',
    );
  }

  String get rememberdaysbefore {
    return Intl.message(
      'Remember days before',
      name: 'rememberdaysbefore',
    );
  }

  String get addthisdevice {
    return Intl.message(
      'Add this device',
      name: 'addthisdevice',
    );
  }

  String get thisdeviceisactive {
    return Intl.message(
      'This device is active',
      name: 'thisdeviceisactive',
    );
  }

  String get fromexistingcourses {
    return Intl.message(
      'From existing course',
      name: 'fromexistingcourses',
    );
  }

  String get onlyadmincancreate {
    return Intl.message(
      'Only the admin can create tasks, lessons etc.',
      name: 'onlyadmincancreate',
    );
  }

  String get cantfindpreviousdata {
    return Intl.message(
      "Can't find previous data?",
      name: 'cantfindpreviousdata',
    );
  }

  String get reportissue {
    return Intl.message(
      "Report issue",
      name: 'reportissue',
    );
  }

  String get info {
    return Intl.message(
      "Info",
      name: 'info',
    );
  }

  String get forgotpassword {
    return Intl.message(
      "Forgot password",
      name: 'forgotpassword',
    );
  }

  String get resetpassword {
    return Intl.message(
      "Reset password",
      name: 'resetpassword',
    );
  }

  String get change {
    return Intl.message(
      "Change",
      name: 'change',
    );
  }

  String get out_lessoninfo {
    return Intl.message(
      "Out",
      name: 'out_lessoninfo',
    );
  }

  String get navigate {
    return Intl.message(
      "Navigate",
      name: 'navigate',
    );
  }

  String get letters {
    return Intl.message(
      "Letters",
      name: 'letters',
    );
  }

  String get activate_forme {
    return Intl.message(
      "Activate for me",
      name: 'activate_forme',
    );
  }

  String get deactivate_forme {
    return Intl.message(
      "Deactivate for me",
      name: 'deactivate_forme',
    );
  }

  String get amount_of_letters_forshortname {
    return Intl.message(
      "Amount of letters for the shortname",
      name: 'amount_of_letters_forshortname',
    );
  }

  String get showfavorites {
    return Intl.message(
      "Show favorites",
      name: 'showfavorites',
    );
  }

  String get centertext {
    return Intl.message(
      "Center text",
      name: 'centertext',
    );
  }

  String get showgrid {
    return Intl.message(
      "Show grid",
      name: 'showgrid',
    );
  }

  String get useshortname {
    return Intl.message(
      "Use shortname",
      name: 'useshortname',
    );
  }

  String get addtoclipboard {
    return Intl.message(
      "Add to clipboard",
      name: 'addtoclipboard',
    );
  }

  String get lessonheight {
    return Intl.message(
      "Lesson height",
      name: 'lessonheight',
    );
  }

  String get weeks {
    return Intl.message(
      "Weeks",
      name: 'weeks',
    );
  }

  String get use_tendencies {
    return Intl.message(
      "Use tendencies",
      name: 'use_tendencies',
    );
  }

  String get use_tendencies_desc {
    return Intl.message(
      "As in the upper grades \(Germany\), e.g. 2+ as 1.7 and 2 as 2.3. If disabled, + and - are not rated, eg. a 3 is counted as 3.",
      name: 'use_tendencies_desc',
    );
  }

  String get openinbrowser {
    return Intl.message(
      "Open in browser",
      name: 'openinbrowser',
    );
  }

  String get compressfile {
    return Intl.message(
      "Compress file",
      name: 'compressfile',
    );
  }

  String get chat {
    return Intl.message(
      "Chat",
      name: 'chat',
    );
  }

  String get entermessage {
    return Intl.message(
      "Enter message...",
      name: 'entermessage',
    );
  }

  String get adminenablechat {
    return Intl.message(
      "You need to enable the chat-feature in order to use it!",
      name: 'adminenablechat',
    );
  }

  String get timeofday {
    return Intl.message(
      "Time of day",
      name: 'timeofday',
    );
  }

  String get starttime {
    return Intl.message(
      "Start time",
      name: 'starttime',
    );
  }

  String get endtime {
    return Intl.message(
      "End time",
      name: 'endtime',
    );
  }

  String get donotshow {
    return Intl.message(
      "Do not show",
      name: 'donotshow',
    );
  }

  String get hide {
    return Intl.message(
      "Hide",
      name: 'hide',
    );
  }

  String get wholetimespan {
    return Intl.message(
      "Whole time span",
      name: 'wholetimespan',
    );
  }

  String get custom {
    return Intl.message(
      "Custom",
      name: 'custom',
    );
  }

  String get timespan {
    return Intl.message(
      "Time span",
      name: 'timespan',
    );
  }

  String get selecttimespan {
    return Intl.message(
      "Select time span",
      name: 'selecttimespan',
    );
  }

  String get lessonafternext {
    return Intl.message(
      "Lesson after next",
      name: 'lessonafternext',
    );
  }

  String get amount_of_days_home {
    return Intl.message(
      "Amount of days in Home",
      name: 'amount_of_days_home',
    );
  }

  String get days_normal {
    return Intl.message(
      "days",
      name: 'days_normal',
    );
  }

  String get changelog {
    return Intl.message(
      "Changelog",
      name: 'changelog',
    );
  }

  String get checkforupdates {
    return Intl.message(
      "Check for updates",
      name: 'checkforupdates',
    );
  }

  String get gradeprofiles {
    return Intl.message(
      "Grade profiles",
      name: 'gradeprofiles',
    );
  }

  String get newgradeprofile {
    return Intl.message(
      "New profile",
      name: 'newgradeprofile',
    );
  }

  String get editgradeprofile {
    return Intl.message(
      "Edit profile",
      name: 'editgradeprofile',
    );
  }

  String get types => Intl.message(
        "Types",
        name: 'types',
      );

  String get newtype => Intl.message(
        "New type",
        name: 'newtype',
      );

  String get gradetypes => Intl.message(
        "Grade types",
        name: 'gradetypes',
      );

  String get mygradeprofile => Intl.message(
        "My grade profile",
        name: 'mygradeprofile',
      );

  String get averageforschoolreport => Intl.message(
        "Average for schoolreport",
        name: 'averageforschoolreport',
      );

  String get averagebytype => Intl.message(
        "Average by type",
        name: 'averagebytype',
      );

  String get averageofallgrades => Intl.message(
        "Average of all grades (simple calculation)",
        name: 'averageofallgrades',
      );

  String get extras => Intl.message(
        "Extras",
        name: 'extras',
      );

  String get testsasoneexam => Intl.message(
        "All tests as one exam",
        name: 'testsasoneexam',
      );

  String get mystorage => Intl.message(
        "My storage",
        name: 'mystorage',
      );

  String get personalstorage => Intl.message(
        "Personal storage",
        name: 'personalstorage',
      );

  String get coursestorage => Intl.message(
        "Course storage",
        name: 'coursestorage',
      );

  String get files => Intl.message(
        "Files",
        name: 'files',
      );

  String get schoolletters => Intl.message(
        "Letters",
        name: 'schoolletters',
      );

  String get newletter => Intl.message(
        "New letter",
        name: 'newletter',
      );
  String get editletter => Intl.message(
        "Edit letter",
        name: 'editletter',
      );
  String get pushnotifications => Intl.message(
        "Push-Notifications",
        name: 'pushnotifications',
      );
  String get allowreply => Intl.message(
        "Allow reply",
        name: 'allowreply',
      );
  String get readby => Intl.message(
        "Read by",
        name: 'readby',
      );
  String get markasread => Intl.message(
        "Mark as read",
        name: 'markasread',
      );
  String get reply => Intl.message(
        "Reply",
        name: 'reply',
      );

  String get justnow => Intl.message(
        "Just now",
        name: 'justnow',
      );

  String get yesterday => Intl.message(
        "Yesterday",
        name: 'yesterday',
      );

  String get details => Intl.message(
        "Details",
        name: 'details',
      );

  String get content => Intl.message(
        "Content",
        name: 'content',
      );

  String get resetresponses => Intl.message(
        "Reset responses/reads",
        name: 'resetresponses',
      );

  String get reset => Intl.message(
        "Reset",
        name: 'reset',
      );

  String get none => Intl.message(
        "None",
        name: 'none',
      );

  String get replied => Intl.message(
        "Replied",
        name: 'replied',
      );

  String get setup => Intl.message(
        "Setup",
        name: 'setup',
      );

  String get continue_ => Intl.message(
        "Continue",
        name: 'continue_',
      );

  String get statistics => Intl.message(
        "Statistics",
        name: 'statistics',
      );

  static Future<MyAppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return MyAppLocalizations();
    });
  }

  static MyAppLocalizations of(BuildContext context) {
    return Localizations.of<MyAppLocalizations>(context, MyAppLocalizations);
  }

  //APPBASE
  String get apptitle {
    return Intl.message(
      'Schoolplanner',
      name: 'apptitle',
      desc: 'Title for application',
    );
  }

  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
    );
  }

  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
    );
  }

  String get version {
    return Intl.message(
      'Version',
      name: 'version',
    );
  }

  String get language {
    return Intl.message(
      'Language',
      name: 'language',
    );
  }
  //END APPBASE

  //MAIN NAVIGATION
  String get navigation {
    return Intl.message(
      'Navigation',
      name: 'navigation',
      desc: '_',
    );
  }

  String get devices {
    return Intl.message(
      'Devices',
      name: 'devices',
      desc: '_',
    );
  }

  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '_',
    );
  }

  String get timetable {
    return Intl.message(
      'Timetable',
      name: 'timetable',
      desc: '_',
    );
  }

  String get upcoming {
    return Intl.message(
      'Upcoming',
      name: 'upcoming',
      desc: '_',
    );
  }

  String get courses {
    return Intl.message(
      'Courses',
      name: 'courses',
      desc: '_',
    );
  }

  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '_',
    );
  }
  //END MAIN NAVIGATION

  //BASICS
  String get selected {
    return Intl.message(
      'Selected',
      name: 'selected',
      desc: '_',
    );
  }

  String get manage {
    return Intl.message(
      'Manage',
      name: 'manage',
      desc: '_',
    );
  }

  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '_',
    );
  }

  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '_',
    );
  }

  String get further {
    return Intl.message(
      'Further',
      name: 'further',
    );
  }

  String get automatic {
    return Intl.message(
      'Automatic',
      name: 'automatic',
    );
  }

  String get failed {
    return Intl.message(
      'Failed',
      name: 'failed',
    );
  }

  String get error {
    return Intl.message(
      'Error',
      name: 'error',
    );
  }

  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
    );
  }

  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
    );
  }

  String get set {
    return Intl.message(
      'Set',
      name: 'set',
    );
  }

  String get general {
    return Intl.message(
      'General',
      name: 'general',
    );
  }

  String get personal {
    return Intl.message(
      'Personal',
      name: 'personal',
    );
  }

  String get configure {
    return Intl.message(
      'Configure',
      name: 'configure',
    );
  }

  String get refreshed {
    return Intl.message(
      'Refreshed',
      name: 'refreshed',
    );
  }

  String get refreshdata {
    return Intl.message(
      'Refresh data',
      name: 'refreshdata',
    );
  }

  String get refreshdata_desc {
    return Intl.message(
      'Refresh courses, timetable and lessontimes for the widget',
      name: 'refreshdata_desc',
    );
  }

  String get functionnotavailable {
    return Intl.message(
      'This feature is currently unavailable.',
      name: 'functionnotavailable',
    );
  }

  String get timebasedtimetable {
    return Intl.message(
      'Time-based timetable',
      name: 'timebasedtimetable',
    );
  }

  String get zerolesson {
    return Intl.message(
      '0. lesson',
      name: 'zerolesson',
    );
  }

  String get weektypes {
    return Intl.message(
      'Weektypes',
      name: 'weektypes',
    );
  }

  String get lessonsperday {
    return Intl.message(
      'Lessons per day',
      name: 'lessonsperday',
    );
  }

  String get multipleweektypes {
    return Intl.message(
      'Multiple weektypes',
      name: 'multipleweektypes',
    );
  }

  String get amountofweektypes {
    return Intl.message(
      'Amount of weektypes',
      name: 'amountofweektypes',
    );
  }

  String get currentweektype {
    return Intl.message(
      'Current weektype',
      name: 'currentweektype',
    );
  }

  String get averagedisplay {
    return Intl.message(
      'Averagedisplay',
      name: 'averagedisplay',
    );
  }

  String get automaticaverage {
    return Intl.message(
      'Automatic average',
      name: 'automaticaverage',
    );
  }

  String get compositionofaverage {
    return Intl.message(
      'Composition of average',
      name: 'compositionofaverage',
    );
  }
  //END BASICS

  //QUICK CREATE
  String get create_quickly {
    return Intl.message(
      'Create quickly',
      name: 'create_quickly',
    );
  }

  String get task {
    return Intl.message(
      'Task',
      name: 'task',
    );
  }

  String get tasks {
    return Intl.message(
      'Tasks',
      name: 'tasks',
    );
  }

  String get event {
    return Intl.message(
      'Event',
      name: 'event',
    );
  }

  String get events {
    return Intl.message(
      'Events',
      name: 'events',
    );
  }

  String get note {
    return Intl.message(
      'Note',
      name: 'note',
    );
  }

  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
    );
  }

  String get grade {
    return Intl.message(
      'Grade',
      name: 'grade',
    );
  }

  String get gradesystem {
    return Intl.message(
      'Gradesystem',
      name: 'gradesystem',
    );
  }

  String get lessoninfo {
    return Intl.message(
      'Lessoninfo',
      name: 'lessoninfo',
    );
  }

  String get lessoninfos {
    return Intl.message(
      'Lessoninfos',
      name: 'lessoninfos',
    );
  }

  String get absenttime {
    return Intl.message(
      'Absenttime',
      name: 'absenttime',
    );
  }

  String get absenttimes {
    return Intl.message(
      'Absenttimes',
      name: 'absenttimes',
    );
  }

  String get timeline {
    return Intl.message(
      'Timeline',
      name: 'timeline',
    );
  }

  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
    );
  }
  //END MAIN NAVIGATION

  //PRIVACY POLICY
  String get privacy {
    return Intl.message(
      'Privacy',
      name: 'privacy',
    );
  }

  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
    );
  }

  String get viewcompleteprivacypolicy {
    return Intl.message(
      'View full Privacy Policy',
      name: 'viewcompleteprivacypolicy',
    );
  }

  String get policy_text_header {
    return Intl.message(
      'We take the protection of your personal data very seriously.',
      name: 'policy_text_header',
    );
  }

  String get policy_text_1 {
    return Intl.message(
      'The data is securely stored and transmitted via https and SSL encryption using Google\'s Firebase',
      name: 'policy_text_1',
    );
  }

  String get policy_text_2 {
    return Intl.message(
      'The data is only stored and not processed.',
      name: 'policy_text_2',
    );
  }

  String get policy_text_3 {
    return Intl.message(
      'No data is transfered to third parties.',
      name: 'policy_text_3',
    );
  }

  String get policy_text_4 {
    return Intl.message(
      'Additional services used are Google Sign-In and Firebase.',
      name: 'policy_text_4',
    );
  }

  String get contact_data_protection_commissioner {
    return Intl.message(
      'Contact data protection comissioner',
      name: 'contact_data_protection_commissioner',
    );
  }

  String get actions {
    return Intl.message(
      'Actions',
      name: 'actions',
    );
  }

  String get remove_data {
    return Intl.message(
      'Remove data completly',
      name: 'remove_data',
    );
  }

  String get retrieve_data {
    return Intl.message(
      'Retrieve stored data',
      name: 'retrieve_data',
    );
  }
  //END PRIVACY POLICY

  //HELP
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
    );
  }

  String get help_wait {
    return Intl.message(
      'There will be helpful tips and guides in the following updates here!',
      name: 'help_wait',
    );
  }
  //END HELP

  //GUIDELINES
  String get guidelines {
    return Intl.message(
      'Guidelines',
      name: 'guidelines',
    );
  }
  //END GUIDELINES

  //ABOUT
  String get about {
    return Intl.message(
      'About',
      name: 'about',
    );
  }

  String get about_contributors {
    return Intl.message(
      'Contributors',
      name: 'about_contributors',
    );
  }

  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
    );
  }

  String get contact_founder {
    return Intl.message(
      'Contact the app founder',
      name: 'contact_founder',
    );
  }

  String get rate_us {
    return Intl.message(
      'Rate us',
      name: 'rate_us',
    );
  }

  String get licenses {
    return Intl.message(
      'Licenses',
      name: 'licenses',
    );
  }

  String get github {
    return Intl.message(
      'GitHub',
      name: 'github',
    );
  }
  //END ABOUT

  //ADVANTAGES
  String get advantages {
    return Intl.message(
      'Advantages',
      name: 'advantages',
    );
  }
  //END ABOUT

  //REGISTRATION
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
    );
  }

  String get signinmethodes {
    return Intl.message(
      'Sign-In methods',
      name: 'signinmethodes',
    );
  }

  String get anonymoususer {
    return Intl.message(
      'Anonymous user',
      name: 'anonymoususer',
    );
  }

  String get gotoprofile {
    return Intl.message(
      'Go to profile',
      name: 'gotoprofile',
    );
  }

  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
    );
  }
  //END REGISTRATION

  //DAYS AND WEEKTYPES
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
    );
  }

  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
    );
  }

  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
    );
  }

  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
    );
  }

  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
    );
  }

  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
    );
  }

  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
    );
  }
  //END DAYS AND WEEKTYPES

  String get archivedplanners {
    return Intl.message(
      'Archived planners',
      name: 'archivedplanners',
    );
  }

  String get value {
    return Intl.message(
      'Value',
      name: 'value',
    );
  }

  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
    );
  }

  String get average {
    return Intl.message(
      'Average',
      name: 'average',
    );
  }

  String get nogrades {
    return Intl.message(
      'No grades',
      name: 'nogrades',
    );
  }

  String get newcourse {
    return Intl.message(
      'New course',
      name: 'newcourse',
    );
  }

  String get editcourse {
    return Intl.message(
      'Edit course',
      name: 'editcourse',
    );
  }

  String get createcourse {
    return Intl.message(
      'Create course',
      name: 'createcourse',
    );
  }

  String get joincourse {
    return Intl.message(
      'Join course',
      name: 'joincourse',
    );
  }

  String get usetemplate {
    return Intl.message(
      'Choose from templates',
      name: 'usetemplate',
    );
  }

  String get myplanners {
    return Intl.message(
      'My planners',
      name: 'myplanners',
    );
  }

  String get view {
    return Intl.message(
      'View',
      name: 'view',
    );
  }

  String get select {
    return Intl.message(
      'Select',
      name: 'select',
    );
  }

  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
    );
  }

  String get qrcode {
    return Intl.message(
      'QR-Code',
      name: 'qrcode',
    );
  }

  String get permissionretrieved {
    return Intl.message(
      'Permission retrieved',
      name: 'permissionretrieved',
    );
  }

  String get nopermissionretrieved {
    return Intl.message(
      'No permission retrieved',
      name: 'nopermissionretrieved',
    );
  }

  String get attachments {
    return Intl.message(
      'Attachments',
      name: 'attachments',
    );
  }

  String get newattachment {
    return Intl.message(
      'New attachment',
      name: 'newattachment',
    );
  }

  String get newfile {
    return Intl.message(
      'New file',
      name: 'newfile',
    );
  }

  String get editfile {
    return Intl.message(
      'Edit file',
      name: 'editfile',
    );
  }

  String get newdesign {
    return Intl.message(
      'New design',
      name: 'newdesign',
    );
  }

  String get editdesign {
    return Intl.message(
      'Edit design',
      name: 'editdesign',
    );
  }

  String get current {
    return Intl.message(
      'Current',
      name: 'current',
    );
  }

  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
    );
  }

  String get of_ {
    return Intl.message(
      'of',
      name: 'of_',
    );
  }

  String get selectfile {
    return Intl.message(
      'Select file',
      name: 'selectfile',
    );
  }

  String get uploading {
    return Intl.message(
      'Uploading',
      name: 'uploading',
    );
  }

  String get eventtype {
    return Intl.message(
      'Eventtype',
      name: 'eventtype',
    );
  }

  String get default_ {
    return Intl.message(
      'Default',
      name: 'default_',
    );
  }

  String get exam {
    return Intl.message(
      'Exam',
      name: 'exam',
    );
  }

  String get test {
    return Intl.message(
      'Test',
      name: 'test',
    );
  }

  String get trip {
    return Intl.message(
      'Trip',
      name: 'trip',
    );
  }

  String get members {
    return Intl.message(
      'Members',
      name: 'members',
    );
  }

  String get security {
    return Intl.message(
      'Security',
      name: 'security',
    );
  }

  String get connectedclasses {
    return Intl.message(
      'Connected schoolclasses',
      name: 'connectedclasses',
    );
  }

  String get mydesign {
    return Intl.message(
      'My design',
      name: 'mydesign',
    );
  }

  String get design {
    return Intl.message(
      'Design',
      name: 'design',
    );
  }

  String get myshortname {
    return Intl.message(
      'My shortname',
      name: 'myshortname',
    );
  }

  String get shortname {
    return Intl.message(
      'Shortname',
      name: 'shortname',
    );
  }

  String get options {
    return Intl.message(
      'Options',
      name: 'options',
    );
  }

  String get connect {
    return Intl.message(
      'Connect',
      name: 'connect',
    );
  }

  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
    );
  }

  String get connected {
    return Intl.message(
      'Connected',
      name: 'connected',
    );
  }

  String get share {
    return Intl.message(
      'Share',
      name: 'share',
    );
  }

  String get addteacher {
    return Intl.message(
      'Add teacher',
      name: 'addteacher',
    );
  }

  String get addplace {
    return Intl.message(
      'Add place',
      name: 'addplace',
    );
  }

  String get templates {
    return Intl.message(
      'Templates',
      name: 'templates',
    );
  }

  String get description {
    return Intl.message(
      'Description',
      name: 'description',
    );
  }

  String get generate {
    return Intl.message(
      'Generate',
      name: 'generate',
    );
  }

  String get removecode {
    return Intl.message(
      'Remove code',
      name: 'removecode',
    );
  }

  String get sharecode {
    return Intl.message(
      'Share code',
      name: 'sharecode',
    );
  }

  String get search {
    return Intl.message(
      'Search',
      name: 'search',
    );
  }

  String get smalldevice {
    return Intl.message(
      'Small device',
      name: 'smalldevice',
    );
  }

  String get noresultfor {
    return Intl.message(
      'No result for',
      name: 'noresultfor',
    );
  }

  String get resultfor {
    return Intl.message(
      'Result for',
      name: 'resultfor',
    );
  }

  String get add {
    return Intl.message(
      'Add',
      name: 'add',
    );
  }

  String get added {
    return Intl.message(
      'Added',
      name: 'added',
    );
  }

  String get addto {
    return Intl.message(
      'Add to',
      name: 'addto',
    );
  }

  String get addtocourses {
    return Intl.message(
      'Add to courses',
      name: 'addtocourses',
    );
  }

  String get addtoclass {
    return Intl.message(
      'Add to schoolclass',
      name: 'addtoclass',
    );
  }

  String get leave {
    return Intl.message(
      'Leave',
      name: 'leave',
    );
  }

  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
    );
  }

  String get leavecourse {
    return Intl.message(
      'Leave course',
      name: 'leavecourse',
    );
  }

  String get publiccode {
    return Intl.message(
      'Public code',
      name: 'publiccode',
    );
  }

  String get newteacher {
    return Intl.message(
      'New teacher',
      name: 'newteacher',
    );
  }

  String get editteacher {
    return Intl.message(
      'Edit teacher',
      name: 'editteacher',
    );
  }

  String get newplace {
    return Intl.message(
      'New place',
      name: 'newplace',
    );
  }

  String get editplace {
    return Intl.message(
      'Edit place',
      name: 'editplace',
    );
  }

  String get address {
    return Intl.message(
      'Address',
      name: 'address',
    );
  }

  String get scancode {
    return Intl.message(
      'Scan code',
      name: 'scancode',
    );
  }
}
