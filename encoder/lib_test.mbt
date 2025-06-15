// Copyright 2024 peter-jerry-ye
// SPDX-License-Identifier: MIT

///|
test "utf8" {
  @encoder.utf8("abcd".iter()).collect()
  |> inspect(content="[b'\\x61', b'\\x62', b'\\x63', b'\\x64']")
  @encoder.utf8("中文❤♥".iter()).collect()
  |> inspect(
    content="[b'\\xE4', b'\\xB8', b'\\xAD', b'\\xE6', b'\\x96', b'\\x87', b'\\xE2', b'\\x9D', b'\\xA4', b'\\xE2', b'\\x99', b'\\xA5']",
  )
  let s = "✓ Hello, 世界! 🌍"
  let bytes = @encoder.utf8(s.iter()).collect()
  inspect(
    bytes,
    content="[b'\\xE2', b'\\x9C', b'\\x93', b'\\x20', b'\\x48', b'\\x65', b'\\x6C', b'\\x6C', b'\\x6F', b'\\x2C', b'\\x20', b'\\xE4', b'\\xB8', b'\\x96', b'\\xE7', b'\\x95', b'\\x8C', b'\\x21', b'\\x20', b'\\xF0', b'\\x9F', b'\\x8C', b'\\x8D']",
  )
}
