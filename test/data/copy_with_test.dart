import 'package:battle_royale_manager/calcul_service/trait_calcul_service.dart';
import 'package:battle_royale_manager/data/combat_stats.dart';
import 'package:battle_royale_manager/data/fighter.dart';
import 'package:battle_royale_manager/data/personality_profile.dart';
import 'package:battle_royale_manager/data/squad.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonalityProfile.copyWith', () {
    const base = PersonalityProfile(
      autonomy: 10,
      aggressivity: 20,
      leadership: 30,
      intelligence: 40,
    );

    test('overrides only the given fields', () {
      final copy = base.copyWith(leadership: 99);
      expect(copy.autonomy, 10);
      expect(copy.aggressivity, 20);
      expect(copy.leadership, 99);
      expect(copy.intelligence, 40);
    });

    test('returns an equivalent profile when called with no arguments', () {
      final copy = base.copyWith();
      expect(copy.autonomy, base.autonomy);
      expect(copy.aggressivity, base.aggressivity);
      expect(copy.leadership, base.leadership);
      expect(copy.intelligence, base.intelligence);
    });
  });

  group('CombatStats.copyWith', () {
    const base = CombatStats(
      carry: 1,
      observation: 2,
      mobility: 3,
      brawl: 4,
      aim: 5,
      tactic: 6,
    );

    test('overrides only the given fields', () {
      final copy = base.copyWith(aim: 42);
      expect(copy.carry, 1);
      expect(copy.observation, 2);
      expect(copy.mobility, 3);
      expect(copy.brawl, 4);
      expect(copy.aim, 42);
      expect(copy.tactic, 6);
    });
  });

  group('Fighter.copyWith', () {
    PersonalityProfile profile = PersonalityProfile(
      autonomy: 10,
      aggressivity: 20,
      leadership: 30,
      intelligence: 40,
    );
    
    Fighter baseFighter() => Fighter(
      name: "f1",
      personalityProfile: profile,
      trait: TraitCalculService.getTrait(profile),
      isTrueTrait: false,
      combatStats: const CombatStats(
        carry: 1,
        observation: 2,
        mobility: 3,
        brawl: 4,
        aim: 5,
        tactic: 6,
      ),
      hp: 100,
      maxHp: 100,
    );

    test('overrides only the given fields', () {
      final fighter = baseFighter();
      final copy = fighter.copyWith(hp: 50);
      expect(copy.hp, 50);
      expect(copy.maxHp, 100);
      expect(copy.personalityProfile, fighter.personalityProfile);
      expect(copy.combatStats, fighter.combatStats);
    });

    test('does not mutate the original fighter', () {
      final fighter = baseFighter();
      fighter.copyWith(hp: 1);
      expect(fighter.hp, 100);
    });
  });

  group('Squad.copyWith', () {
    PersonalityProfile profile = PersonalityProfile(
      autonomy: 10,
      aggressivity: 20,
      leadership: 30,
      intelligence: 40,
    );
    Fighter fighter() => Fighter(
      name: "f1",
      personalityProfile: profile,
      trait: TraitCalculService.getTrait(profile),
      isTrueTrait: false,
      combatStats: const CombatStats(
        carry: 1,
        observation: 2,
        mobility: 3,
        brawl: 4,
        aim: 5,
        tactic: 6,
      ),
      hp: 100,
      maxHp: 100,
    );

    test('overrides the fighters list', () {
      final squad = Squad(fighters: [fighter()]);
      final newFighters = [fighter(), fighter()];
      final copy = squad.copyWith(fighters: newFighters);
      expect(copy.fighters, newFighters);
      expect(squad.fighters.length, 1);
    });

    test('keeps the same fighters when called with no arguments', () {
      final squad = Squad(fighters: [fighter()]);
      final copy = squad.copyWith();
      expect(copy.fighters, squad.fighters);
    });
  });
}
