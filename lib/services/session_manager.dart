import 'dart:convert';
import 'dart:html' as html;

class SessionManager {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _roleKey = 'role';
  static const _userKey = 'loggedInUser'; // ⬅️ simpan AppUser JSON

  static Future<void> saveSession(
    String role, {
    Map<String, dynamic>? userJson,
  }) async {
    html.window.localStorage[_isLoggedInKey] = 'true';
    html.window.localStorage[_roleKey] = role;

    if (userJson != null) {
      html.window.localStorage[_userKey] = jsonEncode(userJson);
    }
  }

  static Future<void> clearSession() async {
    html.window.localStorage.remove(_isLoggedInKey);
    html.window.localStorage.remove(_roleKey);
    html.window.localStorage.remove(_userKey);
  }

  static Future<bool> isLoggedIn() async {
    return html.window.localStorage[_isLoggedInKey] == 'true';
  }

  static Future<String?> getRole() async {
    if (html.window.localStorage[_isLoggedInKey] != 'true') return null;
    return html.window.localStorage[_roleKey];
  }

  static Future<Map<String, dynamic>?> getUserJson() async {
    final raw = html.window.localStorage[_userKey];
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<int?> getUserId() async {
    final json = await getUserJson();
    if (json == null) return null;
    return int.tryParse(json['id'].toString());
  }
}
