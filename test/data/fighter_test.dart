import 'package:battle_royale_manager/calcul_service/trait_calcul_service.dart';
import 'package:battle_royale_manager/constants/fighter_constant.dart';
import 'package:battle_royale_manager/data/fighter.dart';
import 'package:flutter_test/flutter_test.dart';

// A combat stat is `random(0..NATURAL_STAT_WEIGHT-1) + round(baseline)`,
// where baseline is the PROFILE_STAT_WEIGHT-weighted contribution from the
// personality profile.
void _expectStatDerivedFrom(int statValue, int expectedBaseline) {
  expect(statValue, greaterThanOrEqualTo(expectedBaseline));
  expect(
    statValue,
    lessThanOrEqualTo(expectedBaseline + FighterConstant.NATURAL_STAT_WEIGHT - 1),
  );
}

double _profileWeighted(num axisValue) =>
    axisValue * FighterConstant.PROFILE_STAT_WEIGHT / 100;

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

    test('sets maxHp to 50 + carry, and hp equal to maxHp', () {
      for (var i = 0; i < 500; i++) {
        final fighter = Fighter.generate('F$i');
        expect(fighter.maxHp, 50 + fighter.combatStats.carry);
        expect(fighter.hp, fighter.maxHp);
      }
    });

    test(
      'combat stats are derived from the final personalityProfile '
      '(PROFILE_STAT_WEIGHT from the profile axes + up to NATURAL_STAT_WEIGHT random)',
      () {
        for (var i = 0; i < 3000; i++) {
          final fighter = Fighter.generate('F$i');
          final p = fighter.personalityProfile;
          final s = fighter.combatStats;

          _expectStatDerivedFrom(s.carry, _profileWeighted(p.autonomy).round());
          _expectStatDerivedFrom(
            s.observation,
            _profileWeighted(p.intelligence).round(),
          );
          _expectStatDerivedFrom(
            s.mobility,
            _profileWeighted((p.autonomy + p.aggressivity) / 2).round(),
          );
          _expectStatDerivedFrom(
            s.brawl,
            _profileWeighted(p.aggressivity).round(),
          );
          _expectStatDerivedFrom(
            s.aim,
            _profileWeighted((p.aggressivity + p.intelligence) / 2).round(),
          );
          _expectStatDerivedFrom(
            s.tactic,
            _profileWeighted((p.leadership + p.intelligence) / 2).round(),
          );
        }
      },
    );

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

    test(
      'when isTrueTrait is set, the profile is snapped onto the anchor '
      'and the combat stats are derived from that snapped profile',
      () {
        var sawATrueTrait = false;
        // 0.5% chance per fighter; with 20000 draws the odds of never hitting
        // it are astronomically small ((0.995)^20000 ~= 1e-44), so this is
        // not meaningfully flaky in practice.
        for (var i = 0; i < 20000; i++) {
          final fighter = Fighter.generate('F$i');
          if (fighter.isTrueTrait) {
            sawATrueTrait = true;
            final p = fighter.personalityProfile;
            expect(p, fighter.trait.personalityProfile);
            // Regression check: combat stats must be computed from the
            // snapped profile, not from the pre-snap random one.
            _expectStatDerivedFrom(
              fighter.combatStats.carry,
              _profileWeighted(p.autonomy).round(),
            );
          }
        }
        expect(
          sawATrueTrait,
          isTrue,
          reason:
              'expected at least one "Vrai [Trait]" roll to succeed over 20000 fighters',
        );
      },
    );
  });
}
