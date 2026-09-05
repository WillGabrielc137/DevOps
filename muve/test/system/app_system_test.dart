import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muve/main.dart';
import 'package:muve/screens/events/events_screen.dart';

Future<void> _useTestViewport(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(600, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

Future<void> _openLogin(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('abre o aplicativo e valida login sem credenciais', (
    tester,
  ) async {
    await _useTestViewport(tester);
    await _openLogin(tester);

    expect(find.text('Bem-vindo de volta'), findsOneWidget);

    final entrarButton = find.widgetWithText(MaterialButton, 'Entrar');
    await tester.ensureVisible(entrarButton);
    await tester.tap(entrarButton);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Preencha o e-mail e a senha'), findsOneWidget);
  });

  testWidgets('navega ao cadastro de artista e valida formulário vazio', (
    tester,
  ) async {
    await _useTestViewport(tester);
    await _openLogin(tester);

    await tester.tap(find.text('Registre-se agora'));
    await tester.pumpAndSettle();

    expect(find.text('Como deseja se cadastrar?'), findsOneWidget);

    await tester.tap(find.text('Sou Usuário / Artista'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastro de Usuário / Músico'), findsOneWidget);

    final registrarButton = find.widgetWithText(MaterialButton, 'Registrar');
    await tester.ensureVisible(registrarButton);
    await tester.pumpAndSettle();
    await tester.tap(registrarButton);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Preencha todos os campos obrigatórios'), findsOneWidget);
  });

  testWidgets('consulta um show no catálogo e fecha os detalhes', (
    tester,
  ) async {
    await _useTestViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: EventsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Shows em destaque'), findsOneWidget);
    expect(find.text('Imagine Dragons'), findsOneWidget);

    await tester.tap(find.text('Imagine Dragons'));
    await tester.pumpAndSettle();

    expect(find.text('Ingressos'), findsOneWidget);
    expect(find.textContaining('Palco Central'), findsOneWidget);
    expect(find.text('Garanta seu ingresso'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Fechar'));
    await tester.pumpAndSettle();

    expect(find.text('Ingressos'), findsNothing);
    expect(find.text('Shows em destaque'), findsOneWidget);
  });
}
