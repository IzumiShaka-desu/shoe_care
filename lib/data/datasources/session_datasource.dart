import 'package:hive_flutter/hive_flutter.dart';
import 'package:shoe_care/data/models/session_auth.dart';

class SessionDatasource {
  SessionDatasource._internal();
  static final _singleton = SessionDatasource._internal();
  factory SessionDatasource() => _singleton;
  final authBox = Hive.box<String>("auth");
  Future<SessionAuth?> getSession() async {
    final token = authBox.get("token", defaultValue: null);
    final role = authBox.get("role", defaultValue: null);
    if (token == null || role == null) {
      return null;
    }
    final session = SessionAuth(token: token, role: role);
    return session;
  }

  Future<void> saveSession(SessionAuth session) async {
    await authBox.put("token", session.token);
    await authBox.put("role", session.role);
  }

  Future<void> deleteSession() async {
    await authBox.delete("token");
    await authBox.delete("role");
  }
}
