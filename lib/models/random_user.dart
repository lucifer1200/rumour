class RandomUserResponse {
  final List<RandomUserResult> results;

  RandomUserResponse({required this.results});

  factory RandomUserResponse.fromJson(Map<String, dynamic> json) {
    return RandomUserResponse(
      results: List<RandomUserResult>.from(
        (json['results'] as List).map((r) => RandomUserResult.fromJson(r as Map<String, dynamic>)),
      ),
    );
  }
}

class RandomUserResult {
  final String firstName;
  final String lastName;
  final String picture;

  RandomUserResult({
    required this.firstName,
    required this.lastName,
    required this.picture,
  });

  factory RandomUserResult.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    final picture = json['picture'] as Map<String, dynamic>;

    return RandomUserResult(
      firstName: name['first'] as String? ?? '',
      lastName: name['last'] as String? ?? '',
      picture: picture['large'] as String? ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
