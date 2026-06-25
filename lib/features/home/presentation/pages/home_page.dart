import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.utd.uas/nim_channel');
  String _reversedNim = '-';
  final String _nim = '20123006';

  Future<void> _getReversedNim() async {
    try {
      final String result = await platform.invokeMethod('reverseNim', {
        'nim': _nim,
      });
      setState(() {
        _reversedNim = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _reversedNim = "Gagal native: '${e.message}'.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<HomeCubit>()..loadPublicApis(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('UAS App [${EnvConfig.environment}]'),
          backgroundColor: EnvConfig.isProduction
              ? Colors.green
              : Colors.blueGrey,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<HomeCubit>().loadPublicApis(),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NIM Anda: $_nim',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hasil Native Kotlin (Reverse): $_reversedNim',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _getReversedNim,
                    icon: const Icon(Icons.android, size: 18),
                    label: const Text('Jalankan MethodChannel (NIM)'),
                  ),
                  const Divider(),
                  Text(
                    'Base URL: ${EnvConfig.baseUrl}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeSuccess) {
                    final data = state.entries;
                    if (data.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada data tersedia.'),
                      );
                    }
                    return ListView.builder(
                      itemCount: data.length > 20
                          ? 20
                          : data.length, 
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text((index + 1).toString()),
                            ),
                            title: Text(
                              item.api,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(item.description),
                            trailing: Chip(
                              label: Text(
                                item.category,
                                style: const TextStyle(fontSize: 10),
                              ),
                              backgroundColor: Colors.blue.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is HomeFailure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        key: const Key('error_message'),
                        child: Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Memulai memuat data...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
