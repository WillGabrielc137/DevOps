// lib/screens/events/events_contratante_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muve/screens/events/cards/card_regras.dart';
import 'package:muve/screens/events/cards/card_info.dart';
import 'package:muve/theme/app_theme.dart' as theme;
import '../../routes.dart';
import 'cards/card_contratante.dart';

class EventsContratanteScreen extends StatefulWidget {
  const EventsContratanteScreen({super.key});

  @override
  State<EventsContratanteScreen> createState() =>
      _EventsContratanteScreenState();
}

class _EventsContratanteScreenState extends State<EventsContratanteScreen> {
  // lista fixa de artistas
  final artistas = [
    {
      'nome': 'João Silva',
      'descricaoCurta':
          'Sou um artista que toca violão e crio minhas próprias letras e batidas.',
      'descricaoCompleta':
          'Olá! Eu sou João Silva, artista apaixonado por música sertaneja...',
      'image': 'assets/images/images_contrante_events_screen/image_01.jpg',
      'instrumentos': 'Violão, Voz',
      'cidadeEstado': 'São Paulo/SP',
      'dias': 'Sexta, Sábado',
      'horarios': '19h às 23h',
      'estilo': 'Sertanejo',
    },
    {
      'nome': 'Indie Vibes',
      'descricaoCurta': 'Somos uma banda de Rock Indie com 5 integrantes...',
      'descricaoCompleta':
          'Olá! Nós somos a Indie Vibes, uma banda de Rock Indie...',
      'image': 'assets/images/images_contrante_events_screen/image_02.jpg',
      'instrumentos': 'Baixista, Guitarrista, Baterista, Tecladista, Vocalista',
      'cidadeEstado': 'Rio de Janeiro/RJ',
      'dias': 'Quinta, Domingo',
      'horarios': '18h às 22h',
      'estilo': 'Rock Indie',
    },
  ];

  // lista que virá do backend
  final List<Map<String, dynamic>> eventosPublicados = [];

  @override
  void initState() {
    super.initState();
    carregarEventos();
  }

  Future<void> carregarEventos() async {
    try {
      final resp = await http.get(Uri.parse('http://localhost:3000/eventos'));
      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body);
        setState(() {
          eventosPublicados
            ..clear()
            ..addAll(data.map((e) => Map<String, dynamic>.from(e)));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar eventos: ${resp.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro de rede: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = theme.AppTheme.mainGradient;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    'Artistas que querem se apresentar',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                for (var artista in artistas)
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (ctx) => CardContratante(
                              nome: artista['nome']!,
                              descricaoCompleta: artista['descricaoCompleta']!,
                              image: artista['image']!,
                              instrumentos: artista['instrumentos']!,
                              cidadeEstado: artista['cidadeEstado']!,
                              dias: artista['dias']!,
                              horarios: artista['horarios']!,
                              estilo: artista['estilo']!,
                            ),
                      );
                    },
                    child: _buildArtistCell(artista),
                  ),

                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Publique seus Eventos',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: FloatingActionButton(
                      onPressed: () {
                        // abre card de regras antes de criar evento
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder:
                              (ctx) => CardRegras(
                                onConcordar: () async {
                                  Navigator.pop(ctx);
                                  final resultado = await Navigator.pushNamed(
                                    context,
                                    Routes.makeEvents,
                                  );
                                  if (resultado != null && mounted) {
                                    // recarrega eventos do backend depois de publicar
                                    await carregarEventos();
                                  }
                                },
                              ),
                        );
                      },
                      backgroundColor: Colors.white.withOpacity(0.15),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                for (int i = 0; i < eventosPublicados.length; i++)
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (ctx) => CardInfo(evento: eventosPublicados[i]),
                      );
                    },
                    child: _buildEventCell(i),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const _MuveFab(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: _BottomBar(
          onTapEvents:
              () => Navigator.pushReplacementNamed(context, Routes.events),
          onTapSearch: null,
          onTapMessages: null,
          onTapProfileRoute: Routes.profile,
        ),
      ),
    );
  }

  Widget _buildArtistCell(Map<String, dynamic> artista) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              artista['image']!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artista['nome']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artista['descricaoCurta']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildEventCell(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.event, color: Colors.white, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventosPublicados[i]['titulo']?.toString() ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  eventosPublicados[i]['hora']?.toString() ?? '',
                  style: TextStyle(color: Colors.white.withOpacity(0.85)),
                ),
                Text(
                  eventosPublicados[i]['local']?.toString() ?? '',
                  style: TextStyle(color: Colors.white.withOpacity(0.85)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              final id = eventosPublicados[i]['id'];
              if (id != null) {
                final resp = await http.delete(
                  Uri.parse('http://localhost:3000/eventos/$id'),
                );
                if (resp.statusCode == 200) {
                  setState(() => eventosPublicados.removeAt(i));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Evento removido')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao excluir: ${resp.body}')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

/* COMPONENTES REUTILIZÁVEIS */
class _MuveFab extends StatelessWidget {
  const _MuveFab({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      width: 66,
      child: FloatingActionButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.events),
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
                  if (onTapProfileRoute != null)
                    Navigator.pushNamed(context, onTapProfileRoute!);
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
