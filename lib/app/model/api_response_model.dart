class ApiResponseModel<T> {
  
  final bool status;
  final String? message;
  final T? data;

  ApiResponseModel({required this.status,this.message,this.data});
}