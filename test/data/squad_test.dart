import 'package:battle_royale_manager/calcul_service/trait_calcul_service.dart';
import 'package:battle_royale_manager/data/combat_stats.dart';
import 'package:battle_royale_manager/data/fighter.dart';
import 'package:battle_royale_manager/data/personality_profile.dart';
import 'package:battle_royale_manager/data/squad.dart';
import 'package:flutter_test/flutter_test.dart';

Fighter _fighterWith(PersonalityProfile profile, String name) {
  return Fighter(
    name: name,
    personalityProfile: profile,
    trait: TraitCalculService.getTrait(profile),
    isTrueTrait: false,
    combatStats: CombatStats(
      carry: 50,
      observation: 50,
      mobility: 50,
      brawl: 50,
      aim: 50,
      tactic: 50,
    ),
    hp: 100,
    maxHp: 100,
  );
}

void main() {
  group('Squad.getCohesion', () {
    test('returns -1 for an empty squad (current sentinel behaviour)', () {
      final squad = Squad(fighters: []);
      expect(squad.getCohesion(), -1);
    });

    test('returns 100 (max cohesion) for a single-fighter squad', () {
      final squad = Squad(
        fighters: [
          _fighterWith(
            const PersonalityProfile(
              autonomy: 50,
              aggressivity: 50,
              leadership: 50,
              intelligence: 50,
            ),
            "F1",
          ),
        ],
      );
      expect(squad.getCohesion(), 100);
    });

    test(
      'identical profiles (zero dispersion, no leadership gap) score 50',
      () {
        PersonalityProfile same() => const PersonalityProfile(
          autonomy: 50,
          aggressivity: 50,
          leadership: 50,
          intelligence: 50,
        );
        final squad = Squad(
          fighters: [
            _fighterWith(same(), "F1"),
            _fighterWith(same(), "F2"),
            _fighterWith(same(), "F3"),
          ],
        );
        // similarityScore = 100 (no dispersion), hierarchyScore = 0
        // (best leadership == average of the rest) -> 100*0.5 + 0*0.5
        expect(squad.getCohesion(), closeTo(50, 1e-9));
      },
    );

    test(
      'a single standout leader raises the score via the hierarchy term',
      () {
        PersonalityProfile withLeadership(int leadership) => PersonalityProfile(
          autonomy: 50,
          aggressivity: 50,
          leadership: leadership,
          intelligence: 50,
        );
        final squad = Squad(
          fighters: [
            _fighterWith(withLeadership(90), "F1"),
            _fighterWith(withLeadership(40), "F2"),
            _fighterWith(withLeadership(40), "F3"),
          ],
        );
        // similarityScore = 100 (autonomy/aggressivity/intelligence
        // identical across fighters), hierarchyScore = 90 - 40 = 50
        // -> 100*0.5 + 50*0.5
        expect(squad.getCohesion(), closeTo(75, 1e-9));
      },
    );

    test('dispersion on the similarity axes lowers the score', () {
      final squad = Squad(
        fighters: [
          _fighterWith(
            const PersonalityProfile(
              autonomy: 30,
              aggressivity: 30,
              leadership: 50,
              intelligence: 30,
            ),
            "F1",
          ),
          _fighterWith(
            const PersonalityProfile(
              autonomy: 70,
              aggressivity: 70,
              leadership: 50,
              intelligence: 70,
            ),
            "F2",
          ),
          _fighterWith(
            const PersonalityProfile(
              autonomy: 50,
              aggressivity: 50,
              leadership: 50,
              intelligence: 50,
            ),
            "F3",
          ),
        ],
      );
      // Each of autonomy/aggressivity/intelligence has population ecart
      // type sqrt(800/3) for [30, 70, 50]; leadership is constant so the
      // hierarchy term is 0.
      const dispersion = 16.329931618554518; // sqrt(800/3)
      const expected = (100 - dispersion) * 0.5;
      expect(squad.getCohesion(), closeTo(expected, 1e-6));
    });

    test('more dispersed squad scores lower than a uniform squad', () {
      PersonalityProfile p(int a, int b, int c, int d) => PersonalityProfile(
        autonomy: a,
        aggressivity: b,
        leadership: c,
        intelligence: d,
      );
      final uniform = Squad(
        fighters: [
          _fighterWith(p(50, 50, 50, 50), "F1"),
          _fighterWith(p(50, 50, 50, 50), "F2"),
        ],
      );
      final dispersed = Squad(
        fighters: [
          _fighterWith(p(10, 10, 50, 10), "F1"),
          _fighterWith(p(90, 90, 50, 90), "F2"),
        ],
      );
      expect(uniform.getCohesion(), greaterThan(dispersed.getCohesion()));
    });
  });
}
