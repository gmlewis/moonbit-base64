///| `str2bytes` encodes a UTF-16 `String` as a UTF-8 `Bytes`.
pub fn str2bytes(s : String) -> Bytes {
  s.iter() |> @encoder.utf8() |> Bytes::from_iter()
}

///|
test "str2bytes works on simple case" {
  let got = str2bytes("simple case")
  inspect!(
    got,
    content=
      #|b"\x73\x69\x6d\x70\x6c\x65\x20\x63\x61\x73\x65"
    ,
  )
}

///| `str2array` encodes a UTF-16 `String` as a UTF-8 `Array[Byte]`.
/// This is a more convenient version of `str2bytes` for when you want an `Array[Byte]`.
pub fn str2array(s : String) -> Array[Byte] {
  s.iter() |> @encoder.utf8() |> Array::from_iter()
}

///|
test "str2array works on simple case" {
  let got = str2array("simple case")
  inspect!(
    got,
    content="[b'\\x73', b'\\x69', b'\\x6D', b'\\x70', b'\\x6C', b'\\x65', b'\\x20', b'\\x63', b'\\x61', b'\\x73', b'\\x65']",
  )
}
