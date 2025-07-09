///|
/// `str2bytes` encodes a UTF-16 `String` as a UTF-8 `Bytes`.
///
/// Examples:
/// ```
/// inspect(str2bytes("+/ Hello, 世界! 🌍"), content=(
///   #|b"\x2b\x2f\x20\x48\x65\x6c\x6c\x6f\x2c\x20\xe4\xb8\x96\xe7\x95\x8c\x21\x20\xf0\x9f\x8c\x8d"
/// ))
/// ```
pub fn str2bytes(s : String) -> Bytes {
  s.iter() |> @encoder.utf8() |> Bytes::from_iter()
}

///|
test "str2bytes works on simple case" {
  let got = str2bytes("simple case")
  inspect(
    got,
    content=(
      #|b"\x73\x69\x6d\x70\x6c\x65\x20\x63\x61\x73\x65"
    ),
  )
  inspect(
    str2bytes("+/ Hello, 世界! 🌍"),
    content=(
      #|b"\x2b\x2f\x20\x48\x65\x6c\x6c\x6f\x2c\x20\xe4\xb8\x96\xe7\x95\x8c\x21\x20\xf0\x9f\x8c\x8d"
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
  s.iter() |> @encoder.utf8() |> Array::from_iter()
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
