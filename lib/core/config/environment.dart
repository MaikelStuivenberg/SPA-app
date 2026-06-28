/// Build-time configuration via `--dart-define`.
class Environment {
  Environment._();

  static const weatherApiKey = String.fromEnvironment(
    'WEATHER_API_KEY',
    defaultValue: 'bdc5cfb06e9b4c4da4c125836241606',
  );

  static const flickrApiKey = String.fromEnvironment(
    'FLICKR_API_KEY',
    defaultValue: '639f377344ffa79f1f0ebc8349dbae6f',
  );

  static const flickrUserId = String.fromEnvironment(
    'FLICKR_USER_ID',
    defaultValue: '195851792@N04',
  );
}
