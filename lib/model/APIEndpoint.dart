import 'package:kirihare/common/APIConst.dart';

class APIEndpoint {
  String api_endpoint = '';
  String msg = '';

  APIEndpoint();

  factory APIEndpoint.fromJSON(Map<String, dynamic> res){
    APIEndpoint model = new APIEndpoint();
    model.api_endpoint = res[APIConst.api_endpoint];
    model.msg = res[APIConst.msg];
    return model;
  }
}