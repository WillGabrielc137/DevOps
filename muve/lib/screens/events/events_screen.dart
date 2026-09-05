import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:muve/theme/app_theme.dart' as theme;
import '../../routes.dart';
import 'package:muve/screens/events/cards/card_events.dart';
import 'package:muve/data/events_data.dart';
import 'package:muve/services/auth_service.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = theme.AppTheme.mainGradient;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const _MuveFab(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: _BottomBar(
          onTapEvents: () {
            Navigator.pushReplacementNamed(context, Routes.events);
          },
          onTapSearch: null,
          onTapMessages: null,
          onTapProfileRoute: Routes.profile,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _EventsHeader(),
                SizedBox(height: 40),
                _EventsCarousel(), // carrossel com células fixas
                SizedBox(height: 40),
                _GenresHeader(),
                SizedBox(height: 20),
                _GenresGrid(), // grid com estilos musicais
                SizedBox(height: 24),
                _ContratanteActions(), // botão exclusivo do contratante
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* =================== HEADER =================== */

class _EventsHeader extends StatelessWidget {
  const _EventsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Text(
          'Shows em destaque',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/* =================== CARROSSEL =================== */

class _EventsCarousel extends StatelessWidget {
  const _EventsCarousel();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            eventsData.map((event) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (ctx) => CardEvents(
                            title: event['title']!,
                            image: event['image']!,
                            description: event['description']!,
                            dateTime: event['dateTime']!,
                            local: event['local']!,
                            normalPrice: event['normal']!,
                            vipPrice: event['vip']!,
                            camarotePrice: event['camarote']!,
                          ),
                    );
                  },
                  child: Container(
                    width: 130,
                    height: 170,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              event['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event['title']!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

/* =================== GENRES HEADER =================== */

class _GenresHeader extends StatelessWidget {
  const _GenresHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ache um Show que combine com você',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/* =================== GENRES GRID =================== */

class _GenresGrid extends StatelessWidget {
  const _GenresGrid();

  @override
  Widget build(BuildContext context) {
    final genres = [
      {
        'title': 'Sertanejo',
        'image': 'assets/images/images_events_screen/sertanejo_image.jpeg',
        'route': Routes.sertanejo,
      },
      {
        'title': 'Rock',
        'image': 'assets/images/images_events_screen/rock_image.jpg',
        'route': null, // por enquanto
      },
      {
        'title': 'Pagode',
        'image': 'assets/images/images_events_screen/pagode_image.jpeg',
        'route': null,
      },
      {
        'title': 'Eletrônica',
        'image': 'assets/images/images_events_screen/eletronica_image.jpg',
        'route': null,
      },
      {
        'title': 'MPB',
        'image': 'assets/images/images_events_screen/mpb_image.jpg',
        'route': null,
      },
      {
        'title': 'Indie',
        'image': 'assets/images/images_events_screen/indie_image.jpg',
        'route': null,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        return GestureDetector(
          onTap: () {
            if (genre['route'] != null) {
              Navigator.pushNamed(context, genre['route']! as String);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(genre['image']! as String, fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.4)),
                Center(
                  child: Text(
                    genre['title']! as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ============ BOTÃO EXCLUSIVO PARA CONTRATANTE ============ */

/* ============ BOTÃO EXCLUSIVO PARA CONTRATANTE ============ */

class _ContratanteActions extends StatelessWidget {
  const _ContratanteActions();

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    final isContratante =
        user != null &&
        user['tipoConta'] != null &&
        user['tipoConta'].toString().toUpperCase() == 'CONTRATANTE';

    // Se não for contratante, não mostra nada
    if (!isContratante) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () {
            // Vai para a tela exclusiva do contratante
            Navigator.pushNamed(context, Routes.eventsContratante);
          },
          icon: const Icon(Icons.event_available, color: Colors.white),
          label: const Text(
            'Área do contratante',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(106, 27, 154, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}

/* =================== COMPONENTES REUTILIZÁVEIS =================== */

class _MuveFab extends StatelessWidget {
  const _MuveFab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      width: 66,
      child: FloatingActionButton(
        onPressed: () {
          // Agora o botão central apenas garante que está na tela de eventos
          Navigator.pushReplacementNamed(context, Routes.events);
        },
        elevation: 4,
        backgroundColor: Colors.white.withOpacity(0.15),
        shape: const CircleBorder(),
        child: ClipOval(
          child: Image.asset('assets/images/muvelogo.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback? onTapEvents;
  final VoidCallback? onTapSearch;
  final VoidCallback? onTapMessages;
  final String? onTapProfileRoute;

  const _BottomBar({
    super.key,
    this.onTapEvents,
    this.onTapSearch,
    this.onTapMessages,
    this.onTapProfileRoute,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF2D124E).withOpacity(0.92),
        notchMargin: 8,
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.event, label: 'Eventos', onTap: onTapEvents),
              _NavItem(icon: Icons.search, label: 'Buscar', onTap: onTapSearch),
              const SizedBox(width: 84),
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Messages',
                onTap: onTapMessages,
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Perfil',
                onTap: () {
                  if (onTapProfileRoute != null) {
                    Navigator.pushNamed(context, onTapProfileRoute!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.95), size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.profile),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset(
          'assets/images/muvelogo.png',
          height: 44,
          width: 44,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
