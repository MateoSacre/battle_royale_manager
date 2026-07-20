class CombatStats {
  final int carry;
  final int observation;
  final int mobility;
  final int brawl;
  final int aim;
  final int tactic;

  const CombatStats({
    required this.carry,
    required this.observation,
    required this.mobility,
    required this.brawl,
    required this.aim,
    required this.tactic,
  });

  CombatStats copyWith({
    int? carry,
    int? observation,
    int? mobility,
    int? brawl,
    int? aim,
    int? tactic,
  }) {
    return CombatStats(
      carry: carry ?? this.carry,
      observation: observation ?? this.observation,
      mobility: mobility ?? this.mobility,
      brawl: brawl ?? this.brawl,
      aim: aim ?? this.aim,
      tactic: tactic ?? this.tactic,
    );
  }
}
