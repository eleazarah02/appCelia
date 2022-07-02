import 'package:flutter/material.dart';
import 'package:app_bows_celia/screens/screens.dart';
import 'package:app_bows_celia/services/push_notifications_service.dart';
import 'package:app_bows_celia/services/services.dart';
import 'package:provider/provider.dart';

//void main() => runApp(AppState());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> messangerKey =
      GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    PushNotificationService.messagesStream.listen((message) {
      //print('MyApp: $message');
      navigatorKey.currentState?.pushNamed('login', arguments: message);
      final snackBar = SnackBar(content: Text(message));
      messangerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inicio de sesión',
      initialRoute: 'login',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messangerKey,
      routes: {
        'checking': (_) => const CheckAuthScreen(),
        'home': (_) => const HomeScreen(),
        'login': (_) => const LoginScreen(),
        'product': (_) => const ProductScreen(),
        'register': (_) => const RegisterScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.purple),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
          elevation: 0,
        ),
      ),
    );
  }
}
