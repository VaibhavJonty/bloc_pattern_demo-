class SignUpRequest {
  String email;
  String password;
  String password2;
  String username;

  SignUpRequest({this.email, this.password, this.password2, this.username});

  SignUpRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    password2 = json['password2'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['password2'] = this.password2;
    data['username'] = this.username;
    return data;
  }
}

class SignUpResponse {
  String refresh;

  SignUpResponse({this.refresh});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refresh'] = this.refresh;
    return data;
  }
}
