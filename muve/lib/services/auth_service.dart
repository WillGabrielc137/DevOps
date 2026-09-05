import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Vai funcionar via USB com adb reverse
  static const String _baseUrl = 'http://127.0.0.1:3000';

  /// Usuário logado atualmente (vem do backend /auth/login)
  static Map<String, dynamic>? currentUser;

  /// LOGIN
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        // se login OK, salva o usuário (vem com tipoConta, tipoPessoa, etc.)
        if (decoded['success'] == true && decoded['user'] != null) {
          currentUser =
              Map<String, dynamic>.from(decoded['user'] as Map<String, dynamic>);
        } else {
          currentUser = null;
        }
        return decoded;
      } else {
        return {
          'success': false,
          'message': 'Resposta inesperada do servidor',
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Erro ${response.statusCode}: ${response.reasonPhrase}',
      };
    }
  }

  /// REGISTER (cadastro de artista/contratante)
  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> data) async {
    final uri = Uri.parse('$_baseUrl/auth/register');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        return {
          'success': false,
          'message': 'Resposta inesperada do servidor',
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Erro ${response.statusCode}: ${response.reasonPhrase}',
      };
    }
  }

  static void logout() {
    currentUser = null;
  }
}
