/// Returns true if s is either null, empty or is solely made of whitespace characters (as defined by String.trim).

bool isBlank(String s) => s == null || s.trim().isEmpty;

String list2String(List<dynamic> list, String flag){
  String result = "";
  list.forEach((element) {
    if(result == '')
      result = "$element";
    else
      result = "$result""$flag""$element";
  });

  return result;
}

List<String> string2List(String strs, String flag){
  return strs.split(flag);
}