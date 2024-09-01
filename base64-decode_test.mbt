test "url_decode2str: random input cases" {
  let input1 = "eHl6MTI="
  inspect!(@base64.url_decode2str!(input1), content="xyz12")
  let input2 = "YWJjZGVm"
  inspect!(@base64.url_decode2str!(input2), content="abcdef")
  let input3 = "MDEyMzQ1Njc4OQ=="
  inspect!(@base64.url_decode2str!(input3), content="0123456789")
  let input4 = "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo="
  inspect!(
    @base64.url_decode2str!(input4),
    content="ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  )
}

test "url_decode2str: three bytes output" {
  let input = "QUJD"
  inspect!(@base64.url_decode2str!(input), content="ABC")
}

test "url_decode2str: two bytes output" {
  let input = "QUI="
  inspect!(@base64.url_decode2str!(input), content="AB")
}

test "url_decode2str: single byte output" {
  let input = "QQ=="
  inspect!(@base64.url_decode2str!(input), content="A")
}

test "url_decode2str: empty output" {
  let input = ""
  inspect!(@base64.url_decode2str!(input), content="")
}

test "std_decode2str: boundary case with max length" {
  let max_length = 1024 // Assuming a reasonable max length for base64 encoding
  let input =
    #|QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQQ==
  let want = Bytes::make(max_length, b'A')
  let got = @base64.std_decode2bytes!(input)
  assert_eq!(got, want)
}

test "std_decode2str: random input cases" {
  let input1 = "MTIzNA=="
  inspect!(@base64.std_decode2str!(input1), content="1234")
  let input2 = "eHl6YWJj"
  inspect!(@base64.std_decode2str!(input2), content="xyzabc")
  let input3 = "QCMkJV4mKg=="
  inspect!(@base64.std_decode2str!(input3), content="@#$%^&*")
  let input4 = "QUFBQUFBQUE="
  inspect!(@base64.std_decode2str!(input4), content="AAAAAAAA")
}

test "std_decode2str: three bytes output" {
  let input = "QUJD"
  inspect!(@base64.std_decode2str!(input), content="ABC")
}

test "std_decode2str: two bytes output" {
  let input = "QUI="
  inspect!(@base64.std_decode2str!(input), content="AB")
}

test "std_decode2str: single byte output" {
  let input = "QQ=="
  inspect!(@base64.std_decode2str!(input), content="A")
}

test "std_decode2str: empty input" {
  let input = ""
  inspect!(@base64.std_decode2str!(input), content="")
}
