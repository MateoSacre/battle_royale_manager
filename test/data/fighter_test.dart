import 'package:battle_royale_manager/calcul_service/trait_calcul_service.dart';
import 'package:battle_royale_manager/data/fighter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Fighter.generate', () {
    test('keeps the given name', () {
      final fighter = Fighter.generate('Rex');
      expect(fighter.name, 'Rex');
    });

    test('generates personality/combat stats within the 0-99 range', () {
      for (var i = 0; i < 500; i++) {
        final fighter = Fighter.generate('F$i');
        for (final value in [
          fighter.personalityProfile.autonomy,
          fighter.personalityProfile.aggressivity,
          fighter.personalityProfile.leadership,
          fighter.personalityProfile.intelligence,
          fighter.combatStats.carry,
          fighter.combatStats.observation,
          fighter.combatStats.mobility,
          fighter.combatStats.brawl,
          fighter.combatStats.aim,
          fighter.combatStats.tactic,
        ]) {
          expect(value, inInclusiveRange(0, 99));
        }
      }
    });

    test('sets hp equal to maxHp, within the 95-105 range', () {
      for (var i = 0; i < 500; i++) {
        final fighter = Fighter.generate('F$i');
        expect(fighter.maxHp, inInclusiveRange(95, 105));
        expect(fighter.hp, fighter.maxHp);
      }
    });

    test('two generated fighters are not identical (RNG actually advances)', () {
      final a = Fighter.generate('A');
      final b = Fighter.generate('B');
      final same =
          a.personalityProfile.autonomy == b.personalityProfile.autonomy &&
          a.personalityProfile.aggressivity ==
              b.personalityProfile.aggressivity &&
          a.personalityProfile.leadership == b.personalityProfile.leadership &&
          a.personalityProfile.intelligence ==
              b.personalityProfile.intelligence;
      expect(
        same,
        isFalse,
        reason:
            'two consecutive generations landed on the exact same profile; '
            'suspicious if this keeps happening (RNG might be re-seeded per call)',
      );
    });

    test('trait is always the nearest neighbour of the final personalityProfile', () {
      for (var i = 0; i < 3000; i++) {
        final fighter = Fighter.generate('F$i');
        expect(
          TraitCalculService.getTrait(fighter.personalityProfile),
          fighter.trait,
        );
      }
    });

    test('when isTrueTrait is set, the profile is snapped exactly onto the anchor', () {
      var sawATrueTrait = false;
      // 0.5% chance per fighter; with 20000 draws the odds of never hitting
      // it are astronomically small ((0.995)^20000 ~= 1e-44), so this is not
      // meaningfully flaky in practice.
      for (var i = 0; i < 20000; i++) {
        final fighter = Fighter.generate('F$i');
        if (fighter.isTrueTrait) {
          sawATrueTrait = true;
          expect(fighter.personalityProfile, fighter.trait.personalityProfile);
        }
      }
      expect(
        sawATrueTrait,
        isTrue,
        reason: 'expected at least one "Vrai [Trait]" roll to succeed over 20000 fighters',
      );
    });
  });
}
