import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:uas_mobile_lanjut/features/home/data/repositories/api_repository.dart';
import 'package:uas_mobile_lanjut/core/database/isar_service.dart';

class MockDio extends Mock implements Dio {}

class MockIsarService extends Mock implements IsarService {}

void main() {
  late ApiRepository repository;
  late MockDio mockDio;
  late MockIsarService mockIsarService;

  setUp(() {
    mockDio = MockDio();
    mockIsarService = MockIsarService();
    repository = ApiRepository(mockDio, mockIsarService);
  });

  group('ApiRepository Unit Test - Modul 12', () {
    test(
      'Harus mengembalikan daftar data dari API ketika koneksi internet sukses (200)',
      () async {
        final mockResponseData = [
          {
            'api': 'Crypto API',
            'title':
                'Crypto API',
            'description': 'Crypto data description',
            'body': 'Crypto data description',
            'auth': 'apiKey',
            'https': true,
            'cors': 'yes',
            'link': 'https://api.crypto.com',
            'category': 'Finance 6',
          },
        ];

        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/posts'),
            data: mockResponseData,
            statusCode: 200,
          ),
        );

        when(
          () => mockIsarService.savePosts(any()),
        ).thenAnswer((_) async => {});
        final result = await repository.fetchEntries();
        expect(result, isNotEmpty);
        expect(result.first.api, equals('Crypto API'));
      },
    );
  });
}
