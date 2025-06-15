///|
test "url_encode2str: random input cases" {
  let input1 = FixedArray::from_array([b'x', b'y', b'z', b'1', b'2'])
  inspect(@base64.url_encode2str(input1), content="eHl6MTI=")
  let input2 = FixedArray::from_array([b'a', b'b', b'c', b'd', b'e', b'f'])
  inspect(@base64.url_encode2str(input2), content="YWJjZGVm")
  let input3 = FixedArray::from_array([
    b'0', b'1', b'2', b'3', b'4', b'5', b'6', b'7', b'8', b'9',
  ])
  inspect(@base64.url_encode2str(input3), content="MDEyMzQ1Njc4OQ==")
  let input4 = FixedArray::from_array([
    b'A', b'B', b'C', b'D', b'E', b'F', b'G', b'H', b'I', b'J', b'K', b'L', b'M',
    b'N', b'O', b'P', b'Q', b'R', b'S', b'T', b'U', b'V', b'W', b'X', b'Y', b'Z',
  ])
  inspect(
    @base64.url_encode2str(input4),
    content="QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=",
  )
}

///|
test "url_encode2str: three bytes input" {
  let input = FixedArray::from_array([b'A', b'B', b'C'])
  inspect(@base64.url_encode2str(input), content="QUJD")
}

///|
test "url_encode2str: two bytes input" {
  let input = FixedArray::from_array([b'A', b'B'])
  inspect(@base64.url_encode2str(input), content="QUI=")
}

///|
test "url_encode2str: single byte input" {
  let input = FixedArray::from_array([b'A'])
  inspect(@base64.url_encode2str(input), content="QQ==")
}

///|
test "url_encode2str: empty input" {
  let input = FixedArray::from_array([])
  inspect(@base64.url_encode2str(input), content="")
}

///|
test "std_encode2str: boundary case with max length" {
  let max_length = 1024 // Assuming a reasonable max length for base64 encoding
  let input = FixedArray::make(max_length, b'A')
  let expected_output =
    #|QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQQ==
  inspect(@base64.std_encode2str(input), content=expected_output)
}

///|
test "std_encode2str: random input cases" {
  let input1 = FixedArray::from_array([b'1', b'2', b'3', b'4'])
  inspect(@base64.std_encode2str(input1), content="MTIzNA==")
  let input2 = FixedArray::from_array([b'x', b'y', b'z', b'a', b'b', b'c'])
  inspect(@base64.std_encode2str(input2), content="eHl6YWJj")
  let input3 = FixedArray::from_array([b'@', b'#', b'$', b'%', b'^', b'&', b'*'])
  inspect(@base64.std_encode2str(input3), content="QCMkJV4mKg==")
  let input4 = FixedArray::from_array([
    b'A', b'A', b'A', b'A', b'A', b'A', b'A', b'A',
  ])
  inspect(@base64.std_encode2str(input4), content="QUFBQUFBQUE=")
}

///|
test "std_encode2str: three bytes input" {
  let input = FixedArray::from_array([b'A', b'B', b'C'])
  inspect(@base64.std_encode2str(input), content="QUJD")
}

///|
test "std_encode2str: two bytes input" {
  let input = FixedArray::from_array([b'A', b'B'])
  inspect(@base64.std_encode2str(input), content="QUI=")
}

///|
test "std_encode2str: single byte input" {
  let input = FixedArray::from_array([b'A'])
  inspect(@base64.std_encode2str(input), content="QQ==")
}

///|
test "std_encode2str: empty input" {
  let input = FixedArray::from_array([])
  inspect(@base64.std_encode2str(input), content="")
}

///|
let pairs = [
  // RFC 3548 examples
  (b"\x14\xfb\x9c\x03\xd9\x7e", "FPucA9l+"),
  (b"\x14\xfb\x9c\x03\xd9", "FPucA9k="),
  (b"\x14\xfb\x9c\x03", "FPucAw=="),

  // RFC 4648 examples
  (b"", ""),
  (b"f", "Zg=="),
  (b"fo", "Zm8="),
  (b"foo", "Zm9v"),
  (b"foob", "Zm9vYg=="),
  (b"fooba", "Zm9vYmE="),
  (b"foobar", "Zm9vYmFy"),

  // Wikipedia examples
  (b"sure.", "c3VyZS4="),
  (b"sure", "c3VyZQ=="),
  (b"sur", "c3Vy"),
  (b"su", "c3U="),
  (b"leasure.", "bGVhc3VyZS4="),
  (b"easure.", "ZWFzdXJlLg=="),
  (b"asure.", "YXN1cmUu"),
  (b"sure.", "c3VyZS4="),

  // biggest
  (
    b"Twas brillig, and the slithy toves", "VHdhcyBicmlsbGlnLCBhbmQgdGhlIHNsaXRoeSB0b3Zlcw==",
  ),
]

// Do nothing to a reference base64 string (leave in standard format)
///|
fn std_ref(s : String) -> String {
  s
}

// Convert a reference string to URL-encoding
///|
fn url_ref(s : String) -> String {
  let s = s.replace_all(old="+", new="-")
  let s = s.replace_all(old="/", new="_")
  s
}

// Convert a reference string to raw, unpadded format
///|
fn raw_ref(s : String) -> String {
  s.trim_end("=").to_string()
}

// Both URL and unpadding conversions
///|
fn raw_url_ref(s : String) -> String {
  raw_ref(url_ref(s))
}

///|
fn test_std_encode2str(b : FixedArray[Byte]) -> String {
  @base64.std_encode2str(b)
}

///|
fn test_url_encode2str(b : FixedArray[Byte]) -> String {
  @base64.url_encode2str(b)
}

///|
fn raw_std_encode2str(b : FixedArray[Byte]) -> String {
  @base64.std_encode2str(b, no_padding=true)
}

///|
fn raw_url_encode2str(b : FixedArray[Byte]) -> String {
  @base64.url_encode2str(b, no_padding=true)
}

///|
test "pairs encode properly" {
  for tt in pairs {
    for
      enc in [
        (test_std_encode2str, std_ref),
        (test_url_encode2str, url_ref),
        (raw_std_encode2str, raw_ref),
        (raw_url_encode2str, raw_url_ref),
      ] {
      let input = FixedArray::from_array(tt.0.to_array())
      let got = (enc.0)(input)
      let want = (enc.1)(tt.1)
      assert_eq(got, want)
    }
  }
}
