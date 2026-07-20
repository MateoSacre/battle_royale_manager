import 'dart:math';

class GeneralConstant{
  static final bool TEST_MODE = true;
  static final int RANDOM_SEED = TEST_MODE ? 1 : DateTime.timestamp().millisecondsSinceEpoch;
  static final Random GLOBAL_RANDOM = Random(RANDOM_SEED);
}