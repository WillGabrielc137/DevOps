import 'package:flutter/material.dart';
import 'package:muve/error_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_choice_screen.dart';
import 'screens/register_user_screen.dart';
import 'screens/register_client_screen.dart';
import 'screens/profile_screen.dart';

// === telas de eventos ===
import 'screens/events/events_screen.dart';
import 'screens/events/sertanejo_screen.dart';
import 'screens/events/events_contratante_screen.dart';
import 'screens/events/make_events_screen.dart';

class Routes {
  // rotas fixas antigas
  static const splash = '/';
  static const login = '/login';
  static const registerChoice = '/register_choice';
  static const registerUser = '/register_user';
  static const registerClient = '/register_client';
  static const profile = '/profile';

  // rotas de eventos
  static const events = '/events';
  static const sertanejo = '/sertanejo';
  static const error = '/error';
  static const eventsContratante = '/events_contratante';
  static const makeEvents = '/make_events';

  static Map<String, WidgetBuilder> getRoutes() => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    registerChoice: (context) => const RegisterChoiceScreen(),
    registerUser: (context) => const RegisterUserScreen(),
    registerClient: (context) => const RegisterClientScreen(),
    profile: (context) => const ProfileScreen(),

    // novas rotas
    events: (context) => const EventsScreen(),
    sertanejo: (context) => const SertanejoScreen(),
    error: (context) => const ErrorScreen(),
    eventsContratante: (context) => const EventsContratanteScreen(),
    makeEvents: (context) => const MakeEventsScreen(),
  };
}
