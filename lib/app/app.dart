import 'package:flutter/material.dart';

import '../features/home/pages/home_page.dart';
import 'dependencies.dart';
import 'navigation.dart';
import 'theme.dart';

class OlhoNaRuaApp extends StatefulWidget {
  const OlhoNaRuaApp({super.key});

  @override
  State<OlhoNaRuaApp> createState() => _OlhoNaRuaAppState();
}

class _OlhoNaRuaAppState extends State<OlhoNaRuaApp> {
  @override
  void initState() {
    super.initState();
    final notifications = deps.notifications;
    notifications.onTap = openReportFromPayload;
    notifications.launchPayload().then((payload) {
      if (payload != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => openReportFromPayload(payload),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olho na Rua',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
