import 'package:battle_royale_manager/calcul_service/trait_calcul_service.dart';
import 'package:battle_royale_manager/constants/fighter_constant.dart';
import 'package:battle_royale_manager/constants/general_constant.dart';
import 'package:battle_royale_manager/data/combat_stats.dart';
import 'package:battle_royale_manager/data/personality_profile.dart';
import 'package:battle_royale_manager/data/trait.dart';

class Fighter {
  final String name;
  final PersonalityProfile personalityProfile;
  final Trait trait;
  final bool isTrueTrait;
  final CombatStats combatStats;
  final int hp;
  final int maxHp;

  Fighter({
    required this.name,
    required this.personalityProfile,
    required this.trait,
    required this.isTrueTrait,
    required this.combatStats,
    required this.hp,
    required this.maxHp,
  });

  factory Fighter.generate(String name) {
    PersonalityProfile profile = PersonalityProfile(
      autonomy: GeneralConstant.GLOBAL_RANDOM.nextInt(100),
      aggressivity: GeneralConstant.GLOBAL_RANDOM.nextInt(100),
      leadership: GeneralConstant.GLOBAL_RANDOM.nextInt(100),
      intelligence: GeneralConstant.GLOBAL_RANDOM.nextInt(100),
    );
    final trait = TraitCalculService.getTrait(profile);
    final bool isTrueTrait = TraitCalculService.isTrueTrait();
    if (isTrueTrait) {
      profile = trait.personalityProfile;
    }
    final stats = CombatStats(
      carry:
          GeneralConstant.GLOBAL_RANDOM.nextInt(
            FighterConstant.NATURAL_STAT_WEIGHT,
          ) +
          (profile.autonomy * FighterConstant.PROFILE_STAT_WEIGHT / 100)
              .round(),
      observation:
          GeneralConstant.GLOBAL_RANDOM.nextInt(
            FighterConstant.NATURAL_STAT_WEIGHT,
          ) +
          (profile.intelligence * FighterConstant.PROFILE_STAT_WEIGHT / 100)
              .round(),
      mobility:
          GeneralConstant.GLOBAL_RANDOM.nextInt(
            FighterConstant.NATURAL_STAT_WEIGHT,
          ) +
          ((profile.autonomy + profile.aggressivity) /
                  2 *
                  FighterConstant.PROFILE_STAT_WEIGHT /
                  100)
              .round(),
      brawl:
          GeneralConstant.GLOBAL_RANDOM.nextInt(
            FighterConstant.NATURAL_STAT_WEIGHT,
          ) +
          (profile.aggressivity * FighterConstant.PROFILE_STAT_WEIGHT / 100)
              .round(),
      aim:
          GeneralConstant.GLOBAL_RANDOM.nextInt(
            FighterConstant.NATURAL_STAT_WEIGHT,
          ) +
          ((profile.aggressivity + profile.intelligence) /
                  2 *
                  FighterConstant.PROFILE_STAT_WEIGHT /
                  100)
              .round(),
      tactic:
          GeneralConstant.GLOBAL_RANDOM.nextInt(
            FighterConstant.NATURAL_STAT_WEIGHT,
          ) +
          ((profile.leadership + profile.intelligence) /
                  2 *
                  FighterConstant.PROFILE_STAT_WEIGHT /
                  100)
              .round(),
    );
    final maxHp = 50 + stats.carry;
    return Fighter(
      name: name,
      personalityProfile: profile,
      trait: trait,
      isTrueTrait: isTrueTrait,
      combatStats: stats,
      hp: maxHp,
      maxHp: maxHp,
    );
  }

  Fighter copyWith({
    String? name,
    PersonalityProfile? personalityProfile,
    Trait? trait,
    bool? isTrueTrait,
    CombatStats? combatStats,
    int? hp,
    int? maxHp,
  }) {
    return Fighter(
      name: name ?? this.name,
      personalityProfile: personalityProfile ?? this.personalityProfile,
      trait: trait ?? this.trait,
      isTrueTrait: isTrueTrait ?? this.isTrueTrait,
      combatStats: combatStats ?? this.combatStats,
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
    );
  }
}
