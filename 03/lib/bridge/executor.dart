import 'package:_03/model/wrapper.dart';

abstract class Executor {
  int execute({
    required double a,
    required double b,
    required double c,
    required Wrapper<double> x1,
    required Wrapper<double> x2,
  });
}
