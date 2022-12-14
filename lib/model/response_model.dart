// 이 객체모델을 만드는 이유는? 항상 그렇지만 데이터에 대한 집중과 한번에 처리하기 위해서
// 서버에서 메세지를 받는걸 대부분을 이걸 이용해서 처리한다.
class ResponseModel {
  bool _isSuccess;
  String _message;

  ResponseModel(this._isSuccess, this._message);

  String get message => _message;

  bool get isSuccess => _isSuccess;

  set message(String value) {
    _message = value;
  }

  set isSuccess(bool value) {
    _isSuccess = value;
  }
}