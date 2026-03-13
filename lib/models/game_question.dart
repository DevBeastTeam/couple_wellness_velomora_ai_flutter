class GameQuestion {
  final String id;
  final String question;
  final String? category;
  final String? optionA;
  final String? optionB;
  final String? description;
  final String? title;
  final String? budget;
  final String? prompt;
  final String? hint;
  final List<QuizOption>? options;

  GameQuestion({
    required this.id,
    required this.question,
    this.category,
    this.optionA,
    this.optionB,
    this.description,
    this.title,
    this.budget,
    this.prompt,
    this.hint,
    this.options,
  });

  factory GameQuestion.fromJson(Map<String, dynamic> json, {String? id}) {
    // Determine the main text based on common keys
    String qText =
        json['question'] ??
        json['prompt'] ??
        json['title'] ??
        json['description'] ??
        '';

    return GameQuestion(
      id: id ?? json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      question: qText,
      category: json['category'] as String?,
      optionA: json['optionA'] as String?,
      optionB: json['optionB'] as String?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      budget: json['budget'] as String?,
      prompt: json['prompt'] as String?,
      hint: json['hint'] as String?,
      options: json['options'] != null
          ? (json['options'] as List)
                .map((i) => QuizOption.fromJson(Map<String, dynamic>.from(i)))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
      'optionA': optionA,
      'optionB': optionB,
      'description': description,
      'title': title,
      'budget': budget,
      'prompt': prompt,
      'hint': hint,
      'options': options?.map((e) => e.toJson()).toList(),
    };
  }
}

class QuizOption {
  final String text;
  final bool isCorrect;
  final String? language;

  QuizOption({required this.text, required this.isCorrect, this.language});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      text: json['text'] ?? json['language'] ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'isCorrect': isCorrect, 'language': language};
  }
}
