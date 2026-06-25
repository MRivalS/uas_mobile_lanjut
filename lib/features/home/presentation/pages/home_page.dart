import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/config/env_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Samakan nama channel dengan yang ada di Kotlin
  static const _channel = MethodChannel('com.utd.uas/nim_channel');

  String _reversedNimResult = '-';
  final String _mhsNim = '20123006';

  // Fungsi untuk memicu MethodChannel Native Kotlin
  Future<void> _triggerNativeReverse() async {
    try {
      final String result = await _channel.invokeMethod('reverseNim', {
        'nim': _mhsNim,
      });
      setState(() {
        _reversedNimResult = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _reversedNimResult = "Gagal: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UAS App [${EnvConfig.environment}]'),
        backgroundColor: EnvConfig.isProduction
            ? Colors.green
            : Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.rocket_launch,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                'Skeleton Project Siap!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text('NIM Anda: $_mhsNim', style: const TextStyle(fontSize: 16)),
              Text(
                'Hasil Native Kotlin (Reverse): $_reversedNimResult',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Tombol untuk demo di Menit ke 3-7 pada rekaman YouTube Anda
              ElevatedButton.icon(
                onPressed: _triggerNativeReverse,
                icon: const Icon(Icons.android),
                label: const Text('Jalankan MethodChannel (NIM)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'Base URL: ${EnvConfig.baseUrl}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
