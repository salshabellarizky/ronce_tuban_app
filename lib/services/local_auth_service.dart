import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ronce_tuban_app/helpers/db_helper.dart';
import 'package:ronce_tuban_app/models/local_user.dart';

class LocalAuthException implements Exception {
  final String message;

  const LocalAuthException(this.message);

  @override
  String toString() => message;
}

class LocalAuthService {
  Future<LocalUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await DBHelper.instance.database;
    final normalizedEmail = email.trim().toLowerCase();
    final existingUsers = await db.query(
      'local_users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );
    if (existingUsers.isNotEmpty) {
      throw const LocalAuthException('Email sudah terdaftar.');
    }

    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final passwordHash = await _hashPassword(password, salt);

    try {
      final userId = await db.transaction((transaction) async {
        final insertedId = await transaction.insert('local_users', {
          'name': name.trim(),
          'email': normalizedEmail,
          'passwordSalt': base64Encode(salt),
          'passwordHash': base64Encode(passwordHash),
        });
        await _saveSession(transaction, insertedId);
        return insertedId;
      });
      return LocalUser(id: userId, name: name.trim(), email: normalizedEmail);
    } on DatabaseException catch (error) {
      if (error.toString().contains('UNIQUE constraint failed')) {
        throw const LocalAuthException('Email sudah terdaftar.');
      }
      rethrow;
    }
  }

  Future<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(
      'local_users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw const LocalAuthException('Email atau kata sandi salah.');
    }

    final user = rows.first;
    final salt = base64Decode(user['passwordSalt'] as String);
    final expectedHash = base64Decode(user['passwordHash'] as String);
    final actualHash = await _hashPassword(password, salt);
    if (!_constantTimeEquals(actualHash, expectedHash)) {
      throw const LocalAuthException('Email atau kata sandi salah.');
    }

    final userId = user['id'] as int;
    await _saveSession(db, userId);
    return LocalUser(
      id: userId,
      name: user['name'] as String,
      email: user['email'] as String,
    );
  }

  Future<LocalUser?> restoreSession() async {
    final db = await DBHelper.instance.database;
    final sessions = await db.query(
      'local_session',
      where: 'id = 1',
      limit: 1,
    );
    if (sessions.isEmpty) return null;

    final userId = sessions.first['userId'] as int;
    final users = await db.query(
      'local_users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (users.isEmpty) {
      await db.delete('local_session', where: 'id = 1');
      return null;
    }

    final user = users.first;
    return LocalUser(
      id: user['id'] as int,
      name: user['name'] as String,
      email: user['email'] as String,
    );
  }

  Future<void> signOut() async {
    final db = await DBHelper.instance.database;
    await db.delete('local_session', where: 'id = 1');
  }

  Future<List<int>> _hashPassword(String password, List<int> salt) => compute(
        _derivePasswordHash,
        {'password': password, 'salt': salt},
      );

  Future<void> _saveSession(DatabaseExecutor db, int userId) async {
    await db.insert(
      'local_session',
      {'id': 1, 'userId': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  bool _constantTimeEquals(List<int> first, List<int> second) {
    if (first.length != second.length) return false;
    var difference = 0;
    for (var index = 0; index < first.length; index++) {
      difference |= first[index] ^ second[index];
    }
    return difference == 0;
  }
}

Future<List<int>> _derivePasswordHash(Map<String, Object> request) async {
  final passwordHasher = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );
  final secretKey = await passwordHasher.deriveKey(
    secretKey: SecretKey(utf8.encode(request['password'] as String)),
    nonce: request['salt'] as List<int>,
  );
  return secretKey.extractBytes();
}
