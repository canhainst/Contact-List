import 'package:flutter_bloc/flutter_bloc.dart';

/// Language codes used by the app: 'system' means follow device locale
class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super('system');

  String get languageCode => state;

  /// Set language code: 'system', 'en', 'vi', ...
  void setLanguage(String code) => emit(code);
}
