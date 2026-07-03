import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'locale.dart';                 // ✅ Changed from l10n/app_strings.dart
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.init();
  runApp(const DawaCheckApp());
}

class DawaCheckApp extends StatelessWidget {
  const DawaCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleController.instance,
      child: Consumer<LocaleController>(
        builder: (ctx, locale, child) {
          return MaterialApp(
            title: S.of('app_name'),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: locale.lang == AppLang.en
                ? const Locale('en')
                : const Locale('hi'),
            supportedLocales: const [Locale('en'), Locale('hi')],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}