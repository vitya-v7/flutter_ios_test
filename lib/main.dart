import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Test Hello Flutter App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _channel = MethodChannel('sample.viktor/hello');

  int _counter = 0;
  String _fileContent = '';

  Future<void> _onPressed() async {
    _counter++;
    try {
      final result = await _channel.invokeMethod<String>(
        'writeHello',
        {
          'n': _counter,
        },
      );

      setState(() {
        _fileContent = result ?? '';
      });
    } on PlatformException catch (e) {
      setState(() {
        _fileContent = 'Ошибка native: ${e.code} ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _onPressed,
              child: const Text('Добавить "hello world N"'),
            ),
            const SizedBox(height: 16),
            Text('Счётчик нажатий: $_counter'),
            const SizedBox(height: 16),
            const Text('Содержимое файла:'),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _fileContent,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}