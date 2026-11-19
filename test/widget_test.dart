// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronce_tuban_app/main.dart';
import 'package:ronce_tuban_app/helpers/db_helper.dart';
import 'package:ronce_tuban_app/models/local_user.dart';
import 'package:ronce_tuban_app/providers/auth_provider.dart';
import 'package:ronce_tuban_app/providers/quiz_provider.dart';
import 'package:ronce_tuban_app/providers/tradition_provider.dart';
import 'package:ronce_tuban_app/services/local_auth_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  Future<void> pumpApp(WidgetTester tester) async {
    final authProvider = AuthProvider(service: _MemoryAuthService());
    await authProvider.initialize();
    await tester.pumpWidget(
      MyApp(authProvider: authProvider, loadFavorites: false),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Login opens the home page and the quiz introduction',
      (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('Masuk ke aplikasi'), findsOneWidget);
    await tester.ensureVisible(find.text('Masuk ke aplikasi'));
    await tester.tap(find.text('Masuk ke aplikasi'));
    await tester.pump();
    expect(find.text('Email wajib diisi.'), findsOneWidget);

    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();
    final email =
        'pengunjung${DateTime.now().microsecondsSinceEpoch}@example.com';
    await tester.enterText(
        find.byType(TextFormField).at(0), 'Pengunjung Tuban');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      email,
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'rahasia123');
    await tester.enterText(find.byType(TextFormField).at(3), 'rahasia123');
    await tester.ensureVisible(find.text('Buat akun'));
    await tester.tap(find.text('Buat akun'));
    await tester.pumpAndSettle();

    expect(find.text('Ronce Tuban'), findsOneWidget);
    expect(find.text('Cari daerah atau cerita tradisi'), findsOneWidget);
    expect(find.text('Palang'), findsOneWidget);
    expect(find.text('Dus-Dusan'), findsOneWidget);
    expect(find.text('1 tradisi'), findsNWidgets(2));
    expect(find.text('Profil'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
    expect(find.text('Kerek'), findsOneWidget);
    expect(find.text('Tuntunan'), findsOneWidget);

    await tester.ensureVisible(find.text('Kuis Palang'));
    await tester.tap(find.text('Kuis Palang'));
    await tester.pumpAndSettle();
    expect(find.text('Kuis daerah'), findsOneWidget);

    await tester.ensureVisible(find.text('Mulai kuis Palang'));
    await tester.tap(find.text('Mulai kuis Palang'));
    await tester.pumpAndSettle();
    expect(find.text('Pertanyaan 1 dari 5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text(email), findsOneWidget);
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();
    expect(find.text('Masuk ke aplikasi'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), email);
    await tester.enterText(find.byType(TextFormField).at(1), 'rahasia123');
    await tester.ensureVisible(find.text('Masuk ke aplikasi'));
    await tester.tap(find.text('Masuk ke aplikasi'));
    await tester.pumpAndSettle();
    expect(find.text('Ronce Tuban'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();
  });

  testWidgets('Home search filters traditions and shows an empty state',
      (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.ensureVisible(find.text('Jelajahi sebagai tamu'));
    await tester.tap(find.text('Jelajahi sebagai tamu'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cari daerah atau cerita tradisi'));
    await tester.tap(find.text('Cari daerah atau cerita tradisi'));
    await tester.pumpAndSettle();

    expect(find.text('Cari cerita'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Dus-Dusan');
    await tester.pumpAndSettle();
    expect(find.text('Gesikharjo, Palang - Tuban'), findsOneWidget);
    expect(find.text('1 cerita ditemukan'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'tidak ada cerita');
    await tester.pumpAndSettle();
    expect(find.text('Cerita belum ditemukan'), findsOneWidget);

    await tester.tap(find.text('Atur ulang pencarian'));
    await tester.pumpAndSettle();
    expect(find.text('2 cerita ditemukan'), findsOneWidget);
  });

  testWidgets('Tuntunan search opens the tradition detail with its source',
      (WidgetTester tester) async {
    final tuntunan = TraditionProvider().regionKerek.tradisiList.first;
    expect(tuntunan.gambarUrl, contains('encrypted-tbn0.gstatic.com'));

    await pumpApp(tester);
    await tester.ensureVisible(find.text('Jelajahi sebagai tamu'));
    await tester.tap(find.text('Jelajahi sebagai tamu'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cari daerah atau cerita tradisi'));
    await tester.tap(find.text('Cari daerah atau cerita tradisi'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tuntunan');
    await tester.pumpAndSettle();

    expect(find.text('Desa Tengger, Kecamatan Kerek - Tuban'), findsOneWidget);
    await tester.tap(find.text('Desa Tengger, Kecamatan Kerek - Tuban'));
    await tester.pumpAndSettle();

    expect(find.text('Lihat lokasi di Maps'), findsOneWidget);
    expect(
      find.text(
        'Maps menunjukkan area desa; titik pelaksanaan dapat berbeda.',
      ),
      findsOneWidget,
    );
    expect(find.text('Sumber bacaan'), findsOneWidget);
    expect(
      find.text('Tatkala.co — liputan Tuntunan di Desa Gaji, Kerek'),
      findsOneWidget,
    );
    expect(
      find.textContaining(
          'praktik di Tengger dapat memiliki variasi setempat.'),
      findsOneWidget,
    );
  });

  testWidgets('Kerek opens and completes the Tuntunan quiz',
      (WidgetTester tester) async {
    final questions = TraditionProvider().regionKerek.kuisList;
    expect(questions, hasLength(5));

    await pumpApp(tester);
    await tester.ensureVisible(find.text('Jelajahi sebagai tamu'));
    await tester.tap(find.text('Jelajahi sebagai tamu'));
    await tester.pumpAndSettle();

    final exploreButtons = find.text('Jelajahi daerah');
    await tester.ensureVisible(exploreButtons.last);
    await tester.tap(exploreButtons.last);
    await tester.pumpAndSettle();
    expect(find.text('Tradisi di Kerek'), findsOneWidget);
    expect(find.text('Coba kuis Kerek →'), findsOneWidget);

    await tester.ensureVisible(find.text('Coba kuis Kerek →'));
    await tester.tap(find.text('Coba kuis Kerek →'));
    await tester.pumpAndSettle();
    expect(find.text('Kuis Kerek'), findsOneWidget);
    expect(find.text('Mulai kuis Kerek'), findsOneWidget);

    await tester.ensureVisible(find.text('Mulai kuis Kerek'));
    await tester.tap(find.text('Mulai kuis Kerek'));
    await tester.pumpAndSettle();
    expect(find.text('Pertanyaan 1 dari 5'), findsOneWidget);
    expect(find.text('Tuntunan'), findsOneWidget);

    for (var index = 0; index < questions.length; index++) {
      final question = questions[index];
      final correctAnswer = question.pilihan[question.indeksJawabanBenar];
      await tester.ensureVisible(find.text(correctAnswer));
      await tester.tap(find.text(correctAnswer));
      await tester.pump();

      final buttonText = index == questions.length - 1
          ? 'Lihat hasil kuis'
          : 'Konfirmasi jawaban';
      await tester.ensureVisible(find.text(buttonText));
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();
    }

    expect(find.text('Hasil kuis Kerek'), findsOneWidget);
    expect(find.text('5 jawaban benar dari 5 pertanyaan'), findsOneWidget);
  });

  test('Quiz score reflects selected answers and resets cleanly', () {
    final questions = TraditionProvider().regionPalang.kuisList;
    final quiz = QuizProvider();

    for (var index = 0; index < questions.length; index++) {
      final correctIndex = questions[index].indeksJawabanBenar;
      quiz.setJawaban(
        index,
        index == 1
            ? (correctIndex + 1) % questions[index].pilihan.length
            : correctIndex,
      );
    }

    expect(quiz.jumlahJawabanBenar(questions), 4);

    quiz.resetKuis();

    expect(quiz.jawabanPengguna, isEmpty);
    expect(quiz.jumlahJawabanBenar(questions), 0);
  });

  test('Local accounts store salted hashes and support persistent sessions',
      () async {
    final service = LocalAuthService();
    final email = 'auth${DateTime.now().microsecondsSinceEpoch}@example.com';
    final user = await service.register(
      name: 'Pengunjung Tuban',
      email: email,
      password: 'rahasia123',
    );

    expect(user.email, email);
    final database = await DBHelper.instance.database;
    final storedUser = (await database.query(
      'local_users',
      columns: ['passwordSalt', 'passwordHash'],
      where: 'id = ?',
      whereArgs: [user.id],
    ))
        .single;
    expect(storedUser['passwordSalt'], isNotEmpty);
    expect(storedUser['passwordHash'], isNot('rahasia123'));
    expect((await service.restoreSession())?.id, user.id);

    final restoredProvider = AuthProvider(service: service);
    await restoredProvider.initialize();
    expect(restoredProvider.user?.id, user.id);
    await restoredProvider.signOut();
    restoredProvider.dispose();
    expect(await service.restoreSession(), isNull);

    await expectLater(
      service.register(
        name: 'Akun Duplikat',
        email: email,
        password: 'rahasia123',
      ),
      throwsA(isA<LocalAuthException>()),
    );

    final signedIn = await service.signIn(
      email: email,
      password: 'rahasia123',
    );
    expect(signedIn.id, user.id);
    await service.signOut();

    await expectLater(
      service.signIn(email: email, password: 'salah123'),
      throwsA(isA<LocalAuthException>()),
    );
  });
}

class _MemoryAuthService extends LocalAuthService {
  final Map<String, LocalUser> _users = {};
  LocalUser? _currentUser;
  var _nextId = 1;

  @override
  Future<LocalUser?> restoreSession() async => _currentUser;

  @override
  Future<LocalUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.containsKey(normalizedEmail)) {
      throw const LocalAuthException('Email sudah terdaftar.');
    }
    final user = LocalUser(
      id: _nextId++,
      name: name.trim(),
      email: normalizedEmail,
    );
    _users[normalizedEmail] = user;
    _currentUser = user;
    return user;
  }

  @override
  Future<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    final user = _users[email.trim().toLowerCase()];
    if (user == null || password != 'rahasia123') {
      throw const LocalAuthException('Email atau kata sandi salah.');
    }
    _currentUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
