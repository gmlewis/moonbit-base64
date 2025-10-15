///|
/// `str2bytes` encodes a UTF-16 `String` as a UTF-8 `Bytes`.
///
/// Examples:
/// ```
/// inspect(str2bytes("+/ Hello, 世界! 🌍"), content=(
///
///   #|b"+/ Hello, \xe4\xb8\x96\xe7\x95\x8c! \xf0\x9f\x8c\x8d"
///
/// ))
/// ```
pub fn str2bytes(s : String) -> Bytes {
  @encoding/utf8.encode(s)
}

///|
test "str2bytes works on simple case" {
  let got = str2bytes("simple case")
  inspect(
    got,
    content=(
      #|b"simple case"
    ),
  )
  inspect(
    str2bytes("+/ Hello, 世界! 🌍"),
    content=(
      #|b"+/ Hello, \xe4\xb8\x96\xe7\x95\x8c! \xf0\x9f\x8c\x8d"
    ),
  )
}

///|
/// `str2array` encodes a UTF-16 `String` as a UTF-8 `Array[Byte]`.
/// This is a more convenient version of `str2bytes` for when you want an `Array[Byte]`.
///
/// Examples:
/// ```
/// inspect(str2array("🌍"), content="[b'\\xF0', b'\\x9F', b'\\x8C', b'\\x8D']")
/// ```
pub fn str2array(s : String) -> Array[Byte] {
  @encoding/utf8.encode(s) |> Bytes::to_array()
}

///|
test "str2array works on simple case" {
  let got = str2array("simple case")
  inspect(
    got,
    content="[b'\\x73', b'\\x69', b'\\x6D', b'\\x70', b'\\x6C', b'\\x65', b'\\x20', b'\\x63', b'\\x61', b'\\x73', b'\\x65']",
  )
  inspect(str2array("🌍"), content="[b'\\xF0', b'\\x9F', b'\\x8C', b'\\x8D']")
}
