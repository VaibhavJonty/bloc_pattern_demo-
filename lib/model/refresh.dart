class RefreshTokenRequest {
  String refresh;

  RefreshTokenRequest({this.refresh});

  RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refresh'] = this.refresh;
    return data;
  }
}

class RefreshTokenResponse {
  String access;

  RefreshTokenResponse({this.access});

  RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access'] = this.access;
    return data;
  }
}
