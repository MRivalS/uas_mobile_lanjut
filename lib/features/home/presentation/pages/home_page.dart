import 'package:flutter/material.dart';
import '../../../../core/config/env_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UAS App [${EnvConfig.environment}]'),
        backgroundColor: EnvConfig.isProduction
            ? Colors.green
            : Colors.blueGrey,
      ),
      // ... kode bagian atas tetap sama ...
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.rocket_launch, size: 100, color: Colors.blueAccent),
      const SizedBox(height: 20),
      const Text('Skeleton Project Siap!', style: TextStyle(fontSize: 24)),
      const SizedBox(height: 10),
      
      // Menampilkan NIM dan info tema untuk kebutuhan demonstrasi UAS
      Text('NIM: 20123006', 
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[700])),
      
      const SizedBox(height: 5),
      Text('Base URL: ${EnvConfig.baseUrl}', style: const TextStyle(color: Colors.grey)),
    ],
  ),
),
    );
  }
}
