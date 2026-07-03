import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'l10n/app_strings.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.init();
  runApp(const DawaCheckApp());
}

class DawaCheckApp extends StatefulWidget {
  const DawaCheckApp({super.key});

  @override
  State<DawaCheckApp> createState() => _DawaCheckAppState();
}

class _DawaCheckAppState extends State<DawaCheckApp> {
  @override
  void initState() {
    super.initState();
    LocaleController.instance.addListener(_onLocaleChange);
  }

  @override
  void dispose() {
    LocaleController.instance.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DawaCheck',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
