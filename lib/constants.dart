import 'package:flutter_dotenv/flutter_dotenv.dart';

// API server URL
final String apiUrl = dotenv.env['BASE_URL'].toString();
final String apiKey = dotenv.env['API_KEY'].toString();
