import 'package:_01/pendulum_simulation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    builder: (context, child) => const PendulumSimulation(),
  ));
}
