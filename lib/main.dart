import 'package:flutter/material.dart';
import 'core/constants/supabase_constants.dart';
import 'core/themes/app_theme.dart';
import 'services/supabase_service.dart';
import 'config/dependencies/injection_container.dart';
import 'presentation/pages/main/platform_main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );
  
  // Initialize dependency injection
  await InjectionContainer.init();
  
  runApp(const VenyuApp());
}

class VenyuApp extends StatelessWidget {
  const VenyuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venyu',
      theme: AppTheme.lightTheme,
      home: const PlatformMainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}