import 'package:flutter/material.dart';

import 'shared/state/app_state.dart';
import 'shared/widgets/bottom_nav_shell.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      child: MaterialApp(
        title: 'Flutter Catalog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: const BottomNavShell(),
      ),
    );
  }
}
