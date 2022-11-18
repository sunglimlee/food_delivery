class SignUpBody {
  String _name, _phone, _email, _password;
  SignUpBody({required name, required phone, required email, required password}) : _name=name, _phone=phone, _email=email, _password=password ;

  // 데이터를 보내기 위해 JSon 형태가 되어야 하므로 변경하는 함수를 만들어야 한다.
  // 생각보다 JSon 으로 데이터를 변경하는게 어렵지 않다. 너무나도 쉽다.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["f_name"] = this._name;
    data["phone"] = this._phone;
    data["email"] = this._email;
    data["password"] = this._password;
    return data;
  }
}