class PersonalityProfile {
  final int autonomy;
  final int aggressivity;
  final int leadership;
  final int intelligence;

  const PersonalityProfile({
    required this.autonomy,
    required this.aggressivity,
    required this.leadership,
    required this.intelligence,
  });

  PersonalityProfile copyWith({
    int? autonomy,
    int? aggressivity,
    int? leadership,
    int? intelligence,
  }) {
    return PersonalityProfile(
      autonomy: autonomy ?? this.autonomy,
      aggressivity: aggressivity ?? this.aggressivity,
      leadership: leadership ?? this.leadership,
      intelligence: intelligence ?? this.intelligence,
    );
  }
}
