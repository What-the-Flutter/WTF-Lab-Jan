class StateAuth {
  final bool isAuthorized;

  StateAuth({
    required this.isAuthorized,
  });

  StateAuth copyWith({
    bool? isAuthorized,
  }) {
    return StateAuth(
      isAuthorized: isAuthorized ?? this.isAuthorized,
    );
  }
}
