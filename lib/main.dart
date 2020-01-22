import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unpaprd/screens/app.dart';
import 'package:unpaprd/state/playerState.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PlayerStore>(
      create: (ctx) => PlayerStore(),
      child: App(),
    );
  }
}
