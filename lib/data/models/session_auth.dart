class SessionAuth {
  final String token;
  final String? refreshToken;
  final String role;

  SessionAuth({
    required this.token,
    this.refreshToken,
    required this.role,
  });

  factory SessionAuth.fromJson(Map<String, dynamic> json) {
    return SessionAuth(
      token: json['token'],
      refreshToken: json['refreshToken'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
        "role": role,
      };
}
