import 'package:flutter/material.dart';

class CardContratante extends StatelessWidget {
  final String nome;
  final String descricaoCompleta;
  final String image;
  final String instrumentos;
  final String cidadeEstado;
  final String dias;
  final String horarios;
  final String estilo;

  const CardContratante({
    super.key,
    required this.nome,
    required this.descricaoCompleta,
    required this.image,
    required this.instrumentos,
    required this.cidadeEstado,
    required this.dias,
    required this.horarios,
    required this.estilo,
  });

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF2D124E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirmação',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Você tem certeza que deseja fechar contrato com este artista?\n\nVerifique novamente se os dados do artista estão de acordo com seu evento.\n\nAo realizar contrato com esse artista, você estará concordando com nossos termos e condições de comprometimento.\n\nAo confirmar, você e o artista receberão o contrato via e-mail, com os detalhes do contrato e seus valores e demais termos.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  // fecha o diálogo primeiro
                  Navigator.pop(ctx);
                  // dispara o snackbar no contexto raiz (da tela)
                  Future.microtask(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contrato fechado com sucesso!'),
                      ),
                    );
                  });
                },
                child: const Text(
                  'Aceitar',
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D124E), Color(0xFF4A148C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                nome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 300,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                descricaoCompleta,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white54),
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.music_note,
                label: 'Instrumentos',
                value: instrumentos,
              ),
              _InfoRow(
                icon: Icons.place_outlined,
                label: 'Cidade/Estado',
                value: cidadeEstado,
              ),
              _InfoRow(
                icon: Icons.calendar_month_outlined,
                label: 'Dias disponíveis',
                value: dias,
              ),
              _InfoRow(
                icon: Icons.access_time,
                label: 'Horários disponíveis',
                value: horarios,
              ),
              _InfoRow(
                icon: Icons.style_outlined,
                label: 'Estilo',
                value: estilo,
              ),
              const SizedBox(height: 24),
              // === 3 BOTÕES LADO A LADO ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () => _mostrarDialogo(context),
                      icon: const Icon(
                        Icons.assignment_turned_in,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Fechar contrato',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // verde
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // ação enviar mensagem
                      },
                      icon: const Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Enviar mensagem',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(106, 27, 154, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'Fechar',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // vermelho
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
