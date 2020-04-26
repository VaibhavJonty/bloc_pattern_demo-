class ErrorResponse {
  String detail;
  String code;

  ErrorResponse({this.detail, this.code});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detail'] = this.detail;
    data['code'] = this.code;
    return data;
  }
}
