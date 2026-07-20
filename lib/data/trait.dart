import 'package:battle_royale_manager/data/personality_profile.dart';

enum Trait {
  strategist(
    personalityProfile: PersonalityProfile(
      autonomy: 20,
      aggressivity: 25,
      leadership: 80,
      intelligence: 90,
    ),
  ),
  leader(
    personalityProfile: PersonalityProfile(
      autonomy: 25,
      aggressivity: 45,
      leadership: 95,
      intelligence: 70,
    ),
  ),
  hotHead(
    personalityProfile: PersonalityProfile(
      autonomy: 90,
      aggressivity: 95,
      leadership: 20,
      intelligence: 15,
    ),
  ),
  berserker(
    personalityProfile: PersonalityProfile(
      autonomy: 75,
      aggressivity: 95,
      leadership: 45,
      intelligence: 30,
    ),
  ),
  wimp(
    personalityProfile: PersonalityProfile(
      autonomy: 85,
      aggressivity: 5,
      leadership: 15,
      intelligence: 35,
    ),
  ),
  loyal(
    personalityProfile: PersonalityProfile(
      autonomy: 10,
      aggressivity: 45,
      leadership: 20,
      intelligence: 50,
    ),
  ),
  follower(
    personalityProfile: PersonalityProfile(
      autonomy: 10,
      aggressivity: 20,
      leadership: 10,
      intelligence: 25,
    ),
  ),
  sneaky(
    personalityProfile: PersonalityProfile(
      autonomy: 50,
      aggressivity: 20,
      leadership: 5,
      intelligence: 75,
    ),
  ),
  protector(
    personalityProfile: PersonalityProfile(
      autonomy: 25,
      aggressivity: 60,
      leadership: 65,
      intelligence: 65,
    ),
  ),
  opportunist(
    personalityProfile: PersonalityProfile(
      autonomy: 80,
      aggressivity: 50,
      leadership: 25,
      intelligence: 80,
    ),
  ),
  prodigy(
    personalityProfile: PersonalityProfile(
      autonomy: 100,
      aggressivity: 100,
      leadership: 100,
      intelligence: 100,
    ),
  ),
  failure(
    personalityProfile: PersonalityProfile(
      autonomy: 0,
      aggressivity: 0,
      leadership: 0,
      intelligence: 0,
    ),
  );

  const Trait({required this.personalityProfile});

  final PersonalityProfile personalityProfile;
}
