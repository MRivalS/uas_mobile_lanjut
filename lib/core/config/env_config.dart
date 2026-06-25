class EnvConfig {
  EnvConfig._();

  static const String environment = String.fromEnvironment(
    'ENV_NAME',
    defaultValue: 'DEV',
  );
static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com/',
  );

  static bool get isProduction => environment == 'PROD';
}
