import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:universal_commons/platform_check.dart';

class LogAnalytics {
  static bool enabled = PlatformCheck.isMacOS == false;

  static void OpenedJoinLink(String publicKey) {
    if (enabled) {
      FirebaseAnalytics.instance
          .logEvent(name: 'opened_joinbykey_link', parameters: {
        'publicKey': publicKey,
      });
    }
  }

  static void LetterCreated() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'lettercreated');
    }
  }

  static void LetterRead() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'letterread');
    }
  }

  static void LetterAnswered() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'letteranswered');
    }
  }

  static void LetterResponse() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'letterresponse');
    }
  }

  static void LetterResponseReset() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'letterresponsereset');
    }
  }

  static void LetterArchived(bool archived) {
    if (enabled) {
      FirebaseAnalytics.instance
          .logEvent(name: 'letterarchived', parameters: {'value': archived});
    }
  }

  static void LetterChanged() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'letterchanged');
  }

  static void LetterRemoved() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'letterremoved');
  }

  static void TaskCreated() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'taskcreated');
  }

  static void TaskChanged() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'taskchanged');
  }

  static void TaskRemoved() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'taskremoved');
  }

  static void CourseCreated() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'coursecreated');
  }

  static void CourseChanged() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'coursechanged');
  }

  static void CourseRemoved() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'courseremoved');
  }

  static void CourseJoined() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'coursejoined');
  }

  static void SupportAppClickMainScreen() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'supportapp_click_mainscreen');
    }
  }

  static void SupportAppClickAbout() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'supportapp_click_about');
    }
  }

  static void SupportAppHide() {
    if (enabled) FirebaseAnalytics.instance.logEvent(name: 'supportapp_hide');
  }

  static void SupportAppScreenDisplay() {
    if (enabled) {
      FirebaseAnalytics.instance.logEvent(name: 'supportapp_screendisplay');
    }
  }
}
