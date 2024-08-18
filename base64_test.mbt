test "url_encode2str: random input cases" {
  let input1 = FixedArray::from_array([b'x', b'y', b'z', b'1', b'2'])
  inspect!(@base64.url_encode2str(input1), content="eHl6MTI=")
  let input2 = FixedArray::from_array([b'a', b'b', b'c', b'd', b'e', b'f'])
  inspect!(@base64.url_encode2str(input2), content="YWJjZGVm")
  let input3 = FixedArray::from_array(
    [b'0', b'1', b'2', b'3', b'4', b'5', b'6', b'7', b'8', b'9'],
  )
  inspect!(@base64.url_encode2str(input3), content="MDEyMzQ1Njc4OQ==")
  let input4 = FixedArray::from_array(
    [
      b'A', b'B', b'C', b'D', b'E', b'F', b'G', b'H', b'I', b'J', b'K', b'L', b'M',
      b'N', b'O', b'P', b'Q', b'R', b'S', b'T', b'U', b'V', b'W', b'X', b'Y', b'Z',
    ],
  )
  inspect!(
    @base64.url_encode2str(input4),
    content="QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=",
  )
}

test "url_encode2str: three bytes input" {
  let input = FixedArray::from_array([b'A', b'B', b'C'])
  inspect!(@base64.url_encode2str(input), content="QUJD")
}

test "url_encode2str: two bytes input" {
  let input = FixedArray::from_array([b'A', b'B'])
  inspect!(@base64.url_encode2str(input), content="QUI=")
}

test "url_encode2str: single byte input" {
  let input = FixedArray::from_array([b'A'])
  inspect!(@base64.url_encode2str(input), content="QQ==")
}

test "url_encode2str: empty input" {
  let input = FixedArray::from_array([])
  inspect!(@base64.url_encode2str(input), content="")
}

test "std_encode2str: boundary case with max length" {
  let max_length = 1024 // Assuming a reasonable max length for base64 encoding
  let input = FixedArray::make(max_length, b'A')
  let expected_output =
    #|QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQQ==
  inspect!(@base64.std_encode2str(input), content=expected_output)
}

test "std_encode2str: random input cases" {
  let input1 = FixedArray::from_array([b'1', b'2', b'3', b'4'])
  inspect!(@base64.std_encode2str(input1), content="MTIzNA==")
  let input2 = FixedArray::from_array([b'x', b'y', b'z', b'a', b'b', b'c'])
  inspect!(@base64.std_encode2str(input2), content="eHl6YWJj")
  let input3 = FixedArray::from_array(
    [b'@', b'#', b'$', b'%', b'^', b'&', b'*'],
  )
  inspect!(@base64.std_encode2str(input3), content="QCMkJV4mKg==")
  let input4 = FixedArray::from_array(
    [b'A', b'A', b'A', b'A', b'A', b'A', b'A', b'A'],
  )
  inspect!(@base64.std_encode2str(input4), content="QUFBQUFBQUE=")
}

test "std_encode2str: three bytes input" {
  let input = FixedArray::from_array([b'A', b'B', b'C'])
  inspect!(@base64.std_encode2str(input), content="QUJD")
}

test "std_encode2str: two bytes input" {
  let input = FixedArray::from_array([b'A', b'B'])
  inspect!(@base64.std_encode2str(input), content="QUI=")
}

test "std_encode2str: single byte input" {
  let input = FixedArray::from_array([b'A'])
  inspect!(@base64.std_encode2str(input), content="QQ==")
}

test "std_encode2str: empty input" {
  let input = FixedArray::from_array([])
  inspect!(@base64.std_encode2str(input), content="")
}
