import 'dart:math';

import 'package:battle_royale_manager/constants/general_constant.dart';
import 'package:battle_royale_manager/constants/trait_constant.dart';
import 'package:battle_royale_manager/data/personality_profile.dart';
import 'package:battle_royale_manager/data/trait.dart';
import 'package:logging/logging.dart';

final _log = Logger('TraitCalculService');

class TraitCalculService {
  static Trait getTrait(PersonalityProfile personalityProfile) {
    Trait? chosenTrait;
    double? minDistance;
    for (Trait trait in Trait.values) {
      double distance = getDistanceFromTrait(personalityProfile, trait);
      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        chosenTrait = trait;
      }
    }
    if (chosenTrait == null) {
      // TODO: Error
      _log.severe(
        'getTrait found no nearest anchor for $personalityProfile — '
        'this should be unreachable since Trait.values is non-empty',
      );
      return Trait.failure;
    }
    _log.fine(
      'getTrait: $personalityProfile -> $chosenTrait (distance=$minDistance)',
    );
    return chosenTrait;
  }

  static double getDistanceFromTrait(
    PersonalityProfile personalityProfile,
    Trait trait,
  ) {
    return sqrt(
      pow(personalityProfile.autonomy - trait.personalityProfile.autonomy, 2) +
          pow(
            personalityProfile.aggressivity -
                trait.personalityProfile.aggressivity,
            2,
          ) +
          pow(
            personalityProfile.leadership - trait.personalityProfile.leadership,
            2,
          ) +
          pow(
            personalityProfile.intelligence -
                trait.personalityProfile.intelligence,
            2,
          ),
    );
  }

  static bool isTrueTrait() {
    return GeneralConstant.GLOBAL_RANDOM.nextInt(1000) < TraitConstant.TRUE_TRAIT_PROBABILITY;
  }
}
