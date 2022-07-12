// ignore_for_file: file_names

class ErrorResponse {
  ErrorResponse({
      List<String>? message, 
      bool? error,}){
    _message = message;
    _error = error;
}

  ErrorResponse.fromJson(dynamic json) {
    _message = json['message'] != null ? json['message'].cast<String>() : [];
    _error = json['error'];
  }
  List<String>? _message;
  bool? _error;
ErrorResponse copyWith({  List<String>? message,
  bool? error,
}) => ErrorResponse(  message: message ?? _message,
  error: error ?? _error,
);
  List<String>? get message => _message;
  bool? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['error'] = _error;
    return map;
  }

}