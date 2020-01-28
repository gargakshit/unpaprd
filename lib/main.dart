import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:unpaprd/screens/app.dart' as Unpaprd;
import 'package:unpaprd/services/errorHandler.dart';
import 'package:unpaprd/state/playerState.dart';

void main() {
  SentryClient sentry = SentryClient(
    dsn: "https://26552ef431a24755a62b7d3a700ab5a7@sentry.io/2038504",
  );

  FlutterError.onError = (details, {bool forceReport = false}) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  runZoned(
    () => runApp(MyApp()),
    onError: (Object error, StackTrace stackTrace) async {
      handleError(error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PlayerStore>(
      create: (ctx) => PlayerStore(),
      child: Unpaprd.App(),
    );
  }
}
