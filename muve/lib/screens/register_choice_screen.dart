import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../routes.dart';

class RegisterChoiceScreen extends StatefulWidget {
  const RegisterChoiceScreen({super.key});

  @override
  State<RegisterChoiceScreen> createState() => _RegisterChoiceScreenState();
}

class _RegisterChoiceScreenState extends State<RegisterChoiceScreen> {
  bool _pressedUsuario = false;
  bool _pressedContratante = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.purple.shade900,
              Colors.purple.shade800,
              Colors.purple.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  'assets/images/muvelogo.png',
                  height: 280,
                ),
              ),

              const SizedBox(height: 25),

              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 300),
                child: const Text(
                  'Como deseja se cadastrar?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 35),

              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 600),
                child: _buildOptionCard(
                  icon: Icons.mic,
                  title: 'Sou Usuário / Artista',
                  description:
                  'Encontre eventos, bandas e personalize seu perfil para divulgar seu trabalho musical.',
                  route: Routes.registerUser,
                  pressed: _pressedUsuario,
                  onPressedChange: (value) {
                    setState(() => _pressedUsuario = value);
                  },
                ),
              ),

              FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 900),
                child: _buildOptionCard(
                  icon: Icons.calendar_month,
                  title: 'Sou Contratante',
                  description:
                  'Cadastre-se com CPF ou CNPJ para contratar músicos e bandas para seus eventos.',
                  route: Routes.registerClient,
                  pressed: _pressedContratante,
                  onPressedChange: (value) {
                    setState(() => _pressedContratante = value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required String route,
    required bool pressed,
    required Function(bool) onPressedChange,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        elevation: pressed ? 12 : 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTapDown: (_) => onPressedChange(true),
          onTapUp: (_) => onPressedChange(false),
          onTapCancel: () => onPressedChange(false),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 100),
            scale: pressed ? 0.97 : 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade700.withOpacity(0.25),
                        Colors.purple.shade500.withOpacity(0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
