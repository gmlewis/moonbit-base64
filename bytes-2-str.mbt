///| `bytes2str` decodes a UTF-8 `Bytes` to a UTF-16 `String`.
pub fn bytes2str(b : Bytes) -> String {
  let chars = (b.iter() |> @decoder.utf8()).collect()
  let buf = @buffer.new(size_hint=chars.length())
  for ch in chars {
    buf.write_char(ch)
  }
  buf.contents().to_unchecked_string()
}

///|
test "bytes2str works on simple case" {
  let got = bytes2str(b"simple case")
  inspect!(got, content="simple case")
}

///| `array2str` decodes a UTF-8 `ArrayView[Byte]` to a UTF-16 `String`.
/// This is a more convenient version of `bytes2str` for when you have an `ArrayView[Byte]`.
/// If you have an `Array[Byte]`, you can use `array2str(arr[:])`.
pub fn array2str(b : ArrayView[Byte]) -> String {
  let chars = (b.iter() |> @decoder.utf8()).collect()
  let buf = @buffer.new(size_hint=chars.length())
  for ch in chars {
    buf.write_char(ch)
  }
  buf.contents().to_unchecked_string()
}

///|
test "array2str works on simple case" {
  let inp = b"simple case".to_array()
  let got = array2str(inp[:])
  inspect!(got, content="simple case")
}
