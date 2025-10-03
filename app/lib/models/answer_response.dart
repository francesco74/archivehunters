class AnswerResponse {
  final int answerIdResult;
  
  AnswerResponse({
    required this.answerIdResult
  });

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    return AnswerResponse(
      answerIdResult: json['id_answer'],
      );
    }
}