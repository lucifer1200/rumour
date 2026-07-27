import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  bool isDarkMode = true;

  ThemeBloc() : super(ThemeInitial()) {
    on<ToggleTheme>((event, emit) {
      isDarkMode = !isDarkMode;
      emit(ThemeChanged(isDarkMode));
    });

    on<SetTheme>((event, emit) {
      isDarkMode = event.isDark;
      emit(ThemeChanged(isDarkMode));
    });
  }
}
