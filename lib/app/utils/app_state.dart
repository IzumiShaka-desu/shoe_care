import '../enum/screen_status.dart';

class AppState<T> {
  final ScreenStatus screenState;
  final String? errorMessage;
  final T? data;
  AppState({
    this.screenState = ScreenStatus.initial,
    this.errorMessage,
    this.data,
  });
  AppState.initial()
      : screenState = ScreenStatus.initial,
        errorMessage = null,
        data = null;
  AppState.loading()
      : screenState = ScreenStatus.loading,
        errorMessage = null,
        data = null;
  AppState.error(this.errorMessage)
      : screenState = ScreenStatus.error,
        data = null;
  AppState.completed({required this.data})
      : screenState = ScreenStatus.success,
        errorMessage = null;

  bool get isLoading => screenState == ScreenStatus.loading;
  bool get isError => screenState == ScreenStatus.error;
  bool get isSuccess => screenState == ScreenStatus.success;

  AppState<T> copyWith({
    ScreenStatus? screenState,
    String? errorMessage,
    T? data,
  }) {
    return AppState(
      screenState: screenState ?? this.screenState,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}

enum AppStatus {
  // initial,
  authenticated,
  unauthenticated,
}
