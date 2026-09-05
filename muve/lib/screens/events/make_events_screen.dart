// lib/screens/events/make_events_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muve/theme/app_theme.dart' as theme;

class MakeEventsScreen extends StatefulWidget {
  const MakeEventsScreen({super.key});

  @override
  State<MakeEventsScreen> createState() => _MakeEventsScreenState();
}

class _MakeEventsScreenState extends State<MakeEventsScreen> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _localController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _categoriaController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _localController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(
        now.year,
        now.month,
        now.day,
      ), // não deixa dia passado
      lastDate: DateTime(now.year + 5),
      helpText: 'Selecione a data do evento',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        _dataController.text =
            '${twoDigits(picked.day)}/${twoDigits(picked.month)}/${picked.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Selecione o horário de início',
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        _horaController.text =
            '${twoDigits(picked.hour)}:${twoDigits(picked.minute)}';
      });
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
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Publicar Novo Evento',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(
                  controller: _tituloController,
                  hint: 'Título do Evento *',
                  icon: Icons.event,
                ),
                _buildField(
                  controller: _descricaoController,
                  hint: 'Descrição do Evento',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                _buildField(
                  controller: _localController,
                  hint: 'Localização *',
                  icon: Icons.place_outlined,
                ),
                _buildField(
                  controller: _dataController,
                  hint: 'Data (Ex.: 25/09/2025) *',
                  icon: Icons.calendar_month_outlined,
                  readOnly: true,
                  onTap: _pickDate,
                ),
                _buildField(
                  controller: _horaController,
                  hint: 'Horário (Ex.: 19:30) *',
                  icon: Icons.access_time,
                  readOnly: true,
                  onTap: _pickTime,
                ),
                _buildField(
                  controller: _categoriaController,
                  hint: 'Categoria / Estilo',
                  icon: Icons.style_outlined,
                ),
                const SizedBox(height: 30),

                // BOTÃO DE PUBLICAR
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_tituloController.text.trim().isEmpty ||
                          _dataController.text.trim().isEmpty ||
                          _horaController.text.trim().isEmpty ||
                          _localController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preencha os campos obrigatórios (*)',
                            ),
                          ),
                        );
                        return;
                      }

                      final novoEvento = {
                        'titulo': _tituloController.text.trim(),
                        'descricao': _descricaoController.text.trim(),
                        'local': _localController.text.trim(),
                        'data': _dataController.text.trim(),
                        'hora': _horaController.text.trim(),
                        'categoria': _categoriaController.text.trim(),
                      };

                      try {
                        final resp = await http.post(
                          Uri.parse('http://localhost:3000/eventos'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(novoEvento),
                        );

                        if (resp.statusCode == 201) {
                          final eventoCriado = jsonDecode(resp.body);
                          Navigator.pop(
                            context,
                            eventoCriado,
                          ); // volta com o evento
                        } else {
                          String msg = 'Erro ao publicar evento';
                          try {
                            final decoded = jsonDecode(resp.body);
                            if (decoded is Map<String, dynamic> &&
                                decoded['message'] is String) {
                              msg = decoded['message'] as String;
                            }
                          } catch (_) {}
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(msg)));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro de conexão: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      'Publicar Evento',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(106, 27, 154, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // BOTÃO DE CANCELAR
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.black),
          filled: true,
          fillColor: const Color.fromRGBO(220, 176, 255, 1),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
