Duration toDuration(String str) {
  if (str == '') {
    return const Duration(hours: 0);
  }
  final l = str.split(':');
  return Duration(
    hours: int.parse(l[0]),
    minutes: int.parse(l[1]),
    seconds: int.parse(l[2][0] + l[2][1]),
    milliseconds: int.parse(l[2][3] + l[2][4] + l[2][5]),
    microseconds: int.parse(l[2][6] + l[2][7] + l[2][8]),
  );
}