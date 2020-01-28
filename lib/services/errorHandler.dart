import 'package:sentry/sentry.dart';

SentryClient sentry = SentryClient(
  dsn: "https://26552ef431a24755a62b7d3a700ab5a7@sentry.io/2038504",
);

Future<void> handleError(Object error, StackTrace stackTrace) async {
  try {
    await sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
    print('Error sent to sentry.io: $error');
  } catch (e) {
    print('Sending report to sentry.io failed: $e');
    print('Original error: $error');
  }
}
