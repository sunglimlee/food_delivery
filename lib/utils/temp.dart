void main() {
  List<Map<String, dynamic>> getCartHistoryList = [
    {"name": "Chinese Side","time": "2022-10-26 20:36:03.727628"},
    {"name": "Chinese Side","time": "2022-10-26 20:36:03.727628"},
    {"name": "Chinese Side","time": "2022-10-27 20:36:03.727628"},
    {"name": "Chinese Side","time": "2022-10-27 20:36:03.727628"},
    {"name": "Chinese Side","time": "2022-10-28 20:36:03.727628"},
    {"name": "Chinese Side","time": "2022-10-28 20:36:03.727628"},
    {"name": "Chinese Side","time": "2022-10-28 20:36:03.727628"},
    {"name": "Chinese Side","time": "2022-10-28 20:36:03.727628"}
  ];

  for (int i = 0; i < getCartHistoryList.length; i++) {
    //print(getCartHistoryList[i]["time"]); // 이러면 time 을 가져올 수 있다.
  }

  Map<String,int> cartItemsPerOrder = Map();

  var returnedValue = 0;
  for (int i=0; i< getCartHistoryList.length; i++) { // 같은 갯수가 몇개인지 알기 위함.
    if(cartItemsPerOrder.containsKey(getCartHistoryList[i]["time"])) { // key time 의 시간자체를 key 로 만든다는 것.
      // 두번째게 돌때 같은 키값이 있는지 확인하고 있으면 해당하는 키값을 1 증가 시키라는 의미
      returnedValue = cartItemsPerOrder.update(getCartHistoryList[i]["time"], (value)=> ++value);
    } else {
      // time 안에 들어있는 값을 키로하고 그 키값이 없으면 키 값을 1로 정한다.
      cartItemsPerOrder.putIfAbsent(getCartHistoryList[i]["time"], () => 1);
    }
  }
  print(cartItemsPerOrder);
  print(returnedValue);
  /////////////////////////////////////////////////////////////////////////
  returnedValue = 0;
  for (int i=0; i< getCartHistoryList.length; i++) { // 같은 갯수가 몇개인지 알기 위함.
    // 두번째게 돌때 같은 키값이 있는지 확인하고 있으면 해당하는 키값을 1 증가 시키라는 의미
    returnedValue = cartItemsPerOrder.update(getCartHistoryList[i]["time"], (value)=> ++value, ifAbsent: ()=> 1);
  }
  print(cartItemsPerOrder);
  print(returnedValue);
  /////////////////////////////////////////////////////////////////////////

  // 위의 내용과 완전히 같은 버전이다.
  var total = 0;
  getCartHistoryList.forEach((m) {
    cartItemsPerOrder.update((m["time"]), (value) { total++; return ++value; }, ifAbsent: () { total++; return 1; });
  });
  print(cartItemsPerOrder);
  print(total.toString()); // returns the new value
}

