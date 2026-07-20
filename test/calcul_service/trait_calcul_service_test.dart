import 'package:battle_royale_manager/calcul_service/trait_calcul_service.dart';
import 'package:battle_royale_manager/constants/trait_constant.dart';
import 'package:battle_royale_manager/data/personality_profile.dart';
import 'package:battle_royale_manager/data/trait.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getTrait', () {
    test('returns the exact same trait when the profile matches an anchor '
        'exactly (self-consistency for every anchor)', () {
      for (final trait in Trait.values) {
        expect(
          TraitCalculService.getTrait(trait.personalityProfile),
          trait,
          reason: 'anchor for $trait should be its own nearest neighbor',
        );
      }
    });

    test('picks the closest anchor for a profile near "follower"', () {
      // follower anchor: (10, 20, 10, 25) — nudged slightly, still clearly
      // closer to follower than to any other anchor (nearest rival is
      // "loyal" at distance ~27 vs ~3 here).
      const profile = PersonalityProfile(
        autonomy: 12,
        aggressivity: 18,
        leadership: 11,
        intelligence: 26,
      );
      expect(TraitCalculService.getTrait(profile), Trait.follower);
    });

    test('picks the closest anchor between two nearby archetypes', () {
      // Between "hotHead" (90, 95, 20, 15) and "berserker" (75, 95, 45, 30),
      // this point sits much closer to hotHead.
      const profile = PersonalityProfile(
        autonomy: 85,
        aggressivity: 95,
        leadership: 25,
        intelligence: 17,
      );
      expect(TraitCalculService.getTrait(profile), Trait.hotHead);
    });

    test('picks prodigy for a maxed-out profile', () {
      const profile = PersonalityProfile(
        autonomy: 100,
        aggressivity: 100,
        leadership: 100,
        intelligence: 100,
      );
      expect(TraitCalculService.getTrait(profile), Trait.prodigy);
    });

    test('picks failure for a zeroed-out profile', () {
      const profile = PersonalityProfile(
        autonomy: 0,
        aggressivity: 0,
        leadership: 0,
        intelligence: 0,
      );
      expect(TraitCalculService.getTrait(profile), Trait.failure);
    });
  });

  group('getDistanceFromTrait', () {
    test('is 0 when the profile matches the anchor exactly', () {
      for (final trait in Trait.values) {
        expect(
          TraitCalculService.getDistanceFromTrait(
            trait.personalityProfile,
            trait,
          ),
          0,
        );
      }
    });

    test('matches a manually computed euclidean distance', () {
      const profile = PersonalityProfile(
        autonomy: 0,
        aggressivity: 0,
        leadership: 0,
        intelligence: 0,
      );
      // distance to prodigy (100, 100, 100, 100) = sqrt(4 * 100^2)
      expect(
        TraitCalculService.getDistanceFromTrait(profile, Trait.prodigy),
        closeTo(200, 1e-9),
      );
    });
  });

  group('isTrueTrait', () {
    // isTrueTrait() relies on GeneralConstant.GLOBAL_RANDOM, a global,
    // non-injectable Random instance, so individual draws can't be forced
    // deterministically from a test. We instead verify the roll's odds
    // statistically over a large sample.
    test('the configured threshold represents a 0.5% chance', () {
      expect(TraitConstant.TRUE_TRAIT_PROBABILITY / 1000, 0.005);
    });

    test('triggers close to TRUE_TRAIT_PROBABILITY / 1000 of the time', () {
      const trials = 200000;
      var trueCount = 0;
      for (var i = 0; i < trials; i++) {
        if (TraitCalculService.isTrueTrait()) trueCount++;
      }
      final observedRate = trueCount / trials;
      const expectedRate = 0.005;
      // Generous tolerance to keep this non-flaky while still catching a
      // grossly wrong threshold (e.g. off-by-one or off-by-a-factor-of-10).
      expect(observedRate, closeTo(expectedRate, 0.003));
    });
  });
}
