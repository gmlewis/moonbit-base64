// Copyright 2024 peter-jerry-ye
// SPDX-License-Identifier: MIT

///|
test "utf8" {
  @decoder.utf8([b'a', b'b', b'c'].iter()).collect()
  |> inspect!(content="['a', 'b', 'c']")
  @decoder.utf8([b'\xe2', b'\x99', b'\xa5'].iter()).collect()
  |> inspect!(content="['♥']")
  let bytes = b"✓ Hello, 世界! 🌍"
  @decoder.utf8(bytes.iter()).collect()
  |> inspect!(
    content="['✓', ' ', 'H', 'e', 'l', 'l', 'o', ',', ' ', '世', '界', '!', ' ', '🌍']",
  )
  let bytes = [
    b'\xE2', b'\x9C', b'\x93', b'\x20', b'\x48', b'\x65', b'\x6C', b'\x6C', b'\x6F',
    b'\x2C', b'\x20', b'\xE4', b'\xB8', b'\x96', b'\xE7', b'\x95', b'\x8C', b'\x21',
    b'\x20', b'\xF0', b'\x9F', b'\x8C', b'\x8D',
  ]
  let got = @decoder.utf8(bytes.iter()).collect()
  inspect!(
    got,
    content="['✓', ' ', 'H', 'e', 'l', 'l', 'o', ',', ' ', '世', '界', '!', ' ', '🌍']",
  )
}
