class BaseResponse<T> {
  bool success;
  String message;
  T data;
//  Meta meta;

  BaseResponse({this.success, this.message, this.data,/* this.meta*/});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
//    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data;
//    if (this.meta != null) {
//      data['meta'] = this.meta.toJson();
//    }
    return data;
  }
}