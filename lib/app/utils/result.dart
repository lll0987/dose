class Result<T> {
  final bool isSuccess;
  final T? value;
  final String? error;

  Result.success(this.value) : isSuccess = true, error = null;

  Result.failure(this.error) : isSuccess = false, value = null;
}
