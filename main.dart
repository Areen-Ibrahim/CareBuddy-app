import 'package:carebuddy/Core/Constants/bloc_observer.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Services/cache_manager_service.dart';
import 'package:carebuddy/Core/Services/local_notifications_service.dart';
import 'package:carebuddy/Core/Services/notifications_service.dart';
import 'package:carebuddy/Core/Theme/theme.dart';
import 'package:carebuddy/Features/Admin/View/screens/admin_home_page.dart';
import 'package:carebuddy/Features/Admin/View/screens/admin_login_page.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_layout_screen.dart';
import 'package:carebuddy/Features/Shared/View/Screens/choose_user_role_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Core/Services/localizations.dart';
import 'Core/Services/supabase_service.dart';
import 'Features/Parent/View/Screens/parent_layout_screen.dart';
import 'Features/Shared/Controller/shared_cubit.dart';

// Parent
// mohamedhashim27@gmai.com
// S.Goma2a_74
// Babysitter
// hagermonged2019@gmail.com
// S.Goma2a_74

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.value([await MyLocalizations.init(),Bloc.observer = MyBlocObserver(), await CacheManagerService.init(), await LocalNotificationService.init(), await SupabaseService.kInitialize(), await NotificationsService.initialize()]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool loginAsAdmin = false;
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppConstants.kProviders,
      child: BlocBuilder<SharedCubit,SharedStates>(
        buildWhen: (_,current)=> current is ToggleLanguageState,
        builder: (context,state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale(CacheManagerService.readCurrentLanguage()),
            supportedLocales: const
            [
              Locale("ar"),
              Locale("en","US"),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              MyLocalizations.delegate,
            ],
            localeResolutionCallback : (deviceLocale,supportedLocales) {
              for( var locale in supportedLocales )
              {
                if( locale.languageCode == deviceLocale!.languageCode ) return deviceLocale;
              }
              return supportedLocales.first;
            },
            theme: AppTheme.light,
            home: Builder(
              builder: (context){
                if( loginAsAdmin )
                {
                  return CacheManagerService.readAlreadyAdminLogin() == null ? const AdminLoginPage() : const AdminHomePage();
                }
                else
                {
                  return CacheManagerService.readUserID() == null
                      ? const ChooseUserRoleScreen()
                      : CacheManagerService.readUserID()?.type == UserType.Parent.name
                      ? const ParentLayoutScreen()
                      : const BabysitterLayoutScreen();
                }
              },
            ),
          );
        }
      ),
    );
  }
}

