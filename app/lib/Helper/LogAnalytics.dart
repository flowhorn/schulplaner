import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:universal_commons/platform_check.dart';

class LogAnalytics {
  static bool enabled = PlatformCheck.isMacOS == false;

  static void OpenedJoinLink(String publicKey) {
    if (enabled) {
      FirebaseAnalytics().logEvent(name: 'opened_joinbykey_link', parameters: {
        'publicKey': publicKey,
      });
    }
  }

  static void LetterCreated() {
    if (enabled) {
      FirebaseAnalytics().logEvent(name: 'lettercreated');
    }
  }

  static void LetterRead() {
    if (enabled) {
      FirebaseAnalytics().logEvent(name: 'letterread');
    }
  }

  static void LetterAnswered() {
    if (enabled) {
      FirebaseAnalytics().logEvent(name: 'letteranswered');
    }
  }

  static void LetterResponse() {
    if (enabled) {
      FirebaseAnalytics().logEvent(name: 'letterresponse');
    }
  }

  static void LetterResponseReset() {
    if (enabled) {
      FirebaseAnalytics().logEvent(name: 'letterresponsereset');
    }
  }

  static void LetterArchived(bool archived) {
    if (enabled) {
      FirebaseAnalytics()
          .logEvent(name: 'letterarchived', parameters: {'value': archived});
    }
  }

  static void LetterChanged() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'letterchanged');
  }

  static void LetterRemoved() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'letterremoved');
  }

  static void TaskCreated() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'taskcreated');
  }

  static void TaskChanged() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'taskchanged');
  }

  static void TaskRemoved() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'taskremoved');
  }

  static void CourseCreated() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'coursecreated');
  }

  static void CourseChanged() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'coursechanged');
  }

  static void CourseRemoved() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'courseremoved');
  }

  static void CourseJoined() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'coursejoined');
  }

  static void SupportAppClickMainScreen() {
    if (enabled) {
      FirebaseAnalytics().logEvent(name: 'supportapp_click_mainscreen');
    }
  }

  static void SupportAppClickAbout() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'supportapp_click_about');
  }

  static void SupportAppHide() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'supportapp_hide');
  }

  static void SupportAppScreenDisplay() {
    if (enabled) FirebaseAnalytics().logEvent(name: 'supportapp_screendisplay');
  }
}
