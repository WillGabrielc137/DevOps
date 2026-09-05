import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../routes.dart';
import '../services/auth_service.dart'; // importante

class RegisterClientScreen extends StatefulWidget {
  const RegisterClientScreen({super.key});

  @override
  State<RegisterClientScreen> createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  String tipoPessoa = "Pessoa Física";
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Controllers
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final cpfController = TextEditingController();
  final cnpjController = TextEditingController();
  final razaoSocialController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    cpfController.dispose();
    cnpjController.dispose();
    razaoSocialController.dispose();
    super.dispose();
  }

  String formatPhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    } else if (digits.length >= 6) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    } else if (digits.length >= 2) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2)}';
    } else {
      return digits;
    }
  }

  Future<void> _doRegister() async {
    if (nomeController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome, e-mail e senha são obrigatórios')),
      );
      return;
    }

    if (tipoPessoa == "Pessoa Física" && cpfController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CPF é obrigatório para Pessoa Física')),
      );
      return;
    }

    if (tipoPessoa == "Pessoa Jurídica" &&
        (cnpjController.text.isEmpty || razaoSocialController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CNPJ e Razão Social são obrigatórios para PJ'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final data = {
      'nome': nomeController.text.trim(),
      'email': emailController.text.trim(),
      'telefone': telefoneController.text.trim(),
      'senha': senhaController.text,
      'tipoPessoa': tipoPessoa == "Pessoa Jurídica" ? "PJ" : "PF",
      'cpf': tipoPessoa == "Pessoa Física" ? cpfController.text.trim() : null,
      'cnpj':
          tipoPessoa == "Pessoa Jurídica" ? cnpjController.text.trim() : null,
      'razaoSocial':
          tipoPessoa == "Pessoa Jurídica"
              ? razaoSocialController.text.trim()
              : null,
      'tipoConta': "CONTRATANTE", // <- contratante sempre
    };

    try {
      final result = await AuthService.register(data);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, Routes.login);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Erro ao registrar, tente novamente',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao tentar registrar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: Column(
          children: [
            // Parte roxa (gradient)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Image.asset(
                      'assets/images/muvelogo.png',
                      height: 250,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: const Text(
                      "Cadastro de Contratante",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                      "Preencha seus dados para continuar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Parte branca (inputs)
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      _buildInputField(
                        controller: nomeController,
                        hint: "Nome completo",
                        icon: Icons.person,
                        delay: 1400,
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        controller: emailController,
                        hint: "E-mail",
                        icon: Icons.email,
                        delay: 1450,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        controller: telefoneController,
                        hint: "Telefone para autenticação",
                        icon: Icons.phone,
                        delay: 1500,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          final formatted = formatPhoneNumber(val);
                          telefoneController.value = telefoneController.value
                              .copyWith(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                  offset: formatted.length,
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Senha
                      FadeInUp(
                        duration: const Duration(milliseconds: 1550),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: senhaController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: "Senha",
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dropdown PF/PJ
                      FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: DropdownButton<String>(
                            value: tipoPessoa,
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            items:
                                <String>[
                                  "Pessoa Física",
                                  "Pessoa Jurídica",
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                tipoPessoa = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (tipoPessoa == "Pessoa Física")
                        _buildInputField(
                          controller: cpfController,
                          hint: "CPF",
                          icon: Icons.badge,
                          delay: 1700,
                          keyboardType: TextInputType.number,
                        ),
                      if (tipoPessoa == "Pessoa Jurídica") ...[
                        _buildInputField(
                          controller: cnpjController,
                          hint: "CNPJ",
                          icon: Icons.business,
                          delay: 1700,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: razaoSocialController,
                          hint: "Razão Social",
                          icon: Icons.badge,
                          delay: 1800,
                        ),
                      ],

                      const SizedBox(height: 30),

                      FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: MaterialButton(
                          onPressed: _isLoading ? null : _doRegister,
                          height: 45,
                          color: Colors.purple[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      "Registrar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required int delay,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return FadeInUp(
      duration: Duration(milliseconds: delay),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(225, 95, 27, .3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
