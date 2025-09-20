///|
/// `bytes2str` decodes a UTF-8 `Bytes` to a UTF-16 `String`.
///
/// Examples:
/// ```
/// inspect(bytes2str("+/ Hello, 世界! 🌍"), content="+/ Hello, 世界! 🌍")
/// ```
pub fn bytes2str(b : Bytes) -> String {
  let chars = @encoding/utf8.decode_lossy(b)
  let buf = @buffer.new(size_hint=chars.length())
  for ch in chars {
    buf.write_char(ch)
  }
  buf.contents().to_unchecked_string()
}

///|
test "bytes2str works on simple case" {
  let got = bytes2str(b"simple case")
  inspect(got, content="simple case")
  inspect(bytes2str("+/ Hello, 世界! 🌍"), content="+/ Hello, 世界! 🌍")
}

///|
/// `array2str` decodes a UTF-8 `ArrayView[Byte]` to a UTF-16 `String`.
/// This is a more convenient version of `bytes2str` for when you have an `ArrayView[Byte]`.
/// If you have an `Array[Byte]`, you can use `array2str(arr[:])`.
///
/// Examples:
/// ```
/// let arr = b"+/ Hello, 世界! 🌍".to_array()
/// inspect(array2str(arr[:]), content="+/ Hello, 世界! 🌍")
/// ```
pub fn array2str(b : ArrayView[Byte]) -> String {
  let bytes = Bytes::from_iter(b.iter())
  let chars = @encoding/utf8.decode_lossy(bytes)
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
  inspect(got, content="simple case")
  let arr = b"+/ Hello, 世界! 🌍".to_array()
  inspect(array2str(arr[:]), content="+/ Hello, 世界! 🌍")
}
