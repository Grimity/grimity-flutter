import 'package:firebase_analytics/firebase_analytics.dart';

abstract final class AppAnalytics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: _analytics);
}
