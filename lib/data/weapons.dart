enum Weapons {
  knife(damage: 10, isDistant: false),
  gun(damage: 30, isDistant: true);

  const Weapons({required this.damage, required this.isDistant});

  final int damage;
  final bool isDistant;
}
