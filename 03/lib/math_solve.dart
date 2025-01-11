import 'package:_03/bridge/executor.dart';
import 'package:_03/bridge/library.dart';
import 'package:_03/model/wrapper.dart';
import 'package:flutter/material.dart';

class MathSolve extends StatefulWidget {
  const MathSolve({super.key});

  @override
  State<MathSolve> createState() => _MathSolveState();
}

class _MathSolveState extends State<MathSolve> {
  late final TextEditingController _aController;
  late final TextEditingController _bController;
  late final TextEditingController _cController;
  late Executor _executor;
  late String _result;

  @override
  void initState() {
    _aController = TextEditingController();
    _bController = TextEditingController();
    _cController = TextEditingController();
    _result = '';
    _executor = Library();
    super.initState();
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }

  void _solve() {
    final a = double.tryParse(_aController.text) ?? 0;
    final b = double.tryParse(_bController.text) ?? 0;
    final c = double.tryParse(_cController.text) ?? 0;
    final x1 = Wrapper<double>(0);
    final x2 = Wrapper<double>(0);
    final state = _executor.execute(
      a: a,
      b: b,
      c: c,
      x1: x1,
      x2: x2,
    );
    setState(() {
      switch (state) {
        case 0:
          _result = 'Phương trình vô nghiệm';
          break;
        case -1:
          _result = 'Phương trình vô số nghiệm';
          break;
        case 1:
          _result = 'Phương trình có 1 nghiệm duy nhất: x = ${x1.value}';
          break;
        case 2:
          _result = 'Phương trình có nghiệm kép: x1 = x2 = ${x1.value}';
          break;
        case 3:
          _result = 'Phương trình có 2 nghiệm phân biệt: x1 = ${x1.value}, x2 = ${x2.value}';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giải Phương Trình Bậc 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Nhập giá trị a
            TextField(
              controller: _aController,
              decoration: const InputDecoration(
                labelText: 'Hệ số a',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Nhập giá trị b
            TextField(
              controller: _bController,
              decoration: const InputDecoration(
                labelText: 'Hệ số b',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Nhập giá trị c
            TextField(
              controller: _cController,
              decoration: const InputDecoration(
                labelText: 'Hệ số c',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _solve,
              child: const Text('Giải Phương Trình'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
