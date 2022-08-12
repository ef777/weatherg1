import 'dart:io';

class ServerResponse implements HttpException {
  ServerResponse(String type, String header, String messagee) {
    this.type = type;
    this.header = header;
    this.messagee = messagee;
  }

  String? type;
  String? header;
  String? messagee;

  @override
  Uri get uri => throw UnimplementedError();

  @override
  // TODO: implement message
  String get message => throw UnimplementedError();
}
