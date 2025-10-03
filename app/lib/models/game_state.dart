class GameState {
  final int newStatusId;
  final String hint;

  GameState({required this.newStatusId, required this.hint});

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      newStatusId: json['next_status'],
      hint: json['hint'] ?? '',
    );
  }
}
