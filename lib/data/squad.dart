import 'dart:math';

import 'package:battle_royale_manager/calcul_service/cohesion_calcul_service.dart';
import 'package:battle_royale_manager/constants/squad_constant.dart';
import 'package:battle_royale_manager/data/fighter.dart';
import 'package:logging/logging.dart';

final _log = Logger('Squad');

class Squad {
  final List<Fighter> fighters;

  Squad({required this.fighters});

  Squad copyWith({List<Fighter>? fighters}) {
    return Squad(fighters: fighters ?? this.fighters);
  }

  double getCohesion() {
    if (fighters.isEmpty) {
      //error ?
      _log.warning('getCohesion called on an empty squad, returning -1');
      return -1;
    } else if (fighters.length == 1) {
      _log.fine('getCohesion called on a single-fighter squad, returning 100');
      return 100;
    } else {
      List<int> autonomy = [];
      List<int> aggressivity = [];
      List<int> intelligence = [];
      List<int> leadership = [];
      for (Fighter fighter in fighters) {
        autonomy.add(fighter.personalityProfile.autonomy);
        aggressivity.add(fighter.personalityProfile.aggressivity);
        intelligence.add(fighter.personalityProfile.intelligence);
        leadership.add(fighter.personalityProfile.leadership);
      }
      int leaderShipBest = leadership.reduce(max);
      leadership.remove(leaderShipBest);
      double leadershipAverage = CohesionCalculService.getAverageFromInt(
        leadership,
      );
      double autonomyEcartType = CohesionCalculService.getEcartType(autonomy);
      double aggressivityEcartType = CohesionCalculService.getEcartType(
        aggressivity,
      );
      double intelligenceEcartType = CohesionCalculService.getEcartType(
        intelligence,
      );
      double similarityDispersion = CohesionCalculService.getAverageFromDouble([
        autonomyEcartType,
        aggressivityEcartType,
        intelligenceEcartType,
      ]);
      double similarityScore =
          100 - (similarityDispersion * SquadConstant.NORMALISATION_FACTOR);
      double hierarchyScore =
          leaderShipBest - leadershipAverage;
      double cohesion = similarityScore * SquadConstant.SIMILARITY_WEIGHT +
          hierarchyScore * SquadConstant.LEADERSHIP_WEIGHT;
      _log.fine(
        'getCohesion: similarity=$similarityScore, hierarchy=$hierarchyScore, '
        'cohesion=$cohesion (${fighters.length} fighters)',
      );
      return cohesion;
    }
  }
}
