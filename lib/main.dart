import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/chat_provider.dart';
import 'providers/horoscope_provider.dart';
import 'providers/birth_chart_provider.dart';
import 'providers/sky_map_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/compatibility_provider.dart';
import 'providers/social_feed_provider.dart';
import 'services/storage_service.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);

  runApp(AstroMiniApp(storageService: storageService));
}

class AstroMiniApp extends StatelessWidget {
  final StorageService storageService;

  const AstroMiniApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HoroscopeProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = BirthChartProvider(storageService);
            provider.loadSavedBirthData();
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => SkyMapProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => CompatibilityProvider()),
        ChangeNotifierProvider(create: (_) => SocialFeedProvider()),
        ChangeNotifierProxyProvider2<BirthChartProvider, UserProfileProvider,
            ChatProvider>(
          create: (_) => ChatProvider(),
          update: (_, chartProv, profileProv, chatProv) {
            chatProv!.updateContext(chartProv.chart, profileProv.profile);
            return chatProv;
          },
        ),
      ],
      child: MaterialApp(
        title: 'astromini',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainShell(),
      ),
    );
  }
}
