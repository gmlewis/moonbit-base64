/// This package is based on the Go implementation found here:
/// https://cs.opensource.google/go/go/+/master:src/encoding/base64/base64.go
/// which has the copyright notice:
/// Copyright 2009 The Go Authors. All rights reserved.
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file.

/// `std_decode2bytes` base64-decodes the provided bytes using Standard encoding.
pub fn std_decode2bytes(src : String) -> Bytes {
  if src.length() == 0 {
    return Bytes::from_array([])
  }
  let buf = FixedArray::make(decoded_len(src.length()), b'\x00')
  let src = str2bytes(src)
  decode_buf(std_encoding, buf, src)
  Bytes::from_iter(buf.iter())
}

/// `std_decode2str` base64-decodes the provided bytes using Standard encoding and returns a String.
pub fn std_decode2str(src : String) -> String {
  bytes2str(std_decode2bytes(src))
}

/// `url_decode2bytes` base64-decodes the provided bytes using URL encoding.
pub fn url_decode2bytes(src : String) -> Bytes {
  if src.length() == 0 {
    return Bytes::from_array([])
  }
  let buf = FixedArray::make(decoded_len(src.length()), b'\x00')
  let src = str2bytes(src)
  decode_buf(url_encoding, buf, src)
  Bytes::from_iter(buf.iter())
}

/// `url_decode2str` base64-decodes the provided bytes using URL encoding and returns a String.
pub fn url_decode2str(src : String) -> String {
  bytes2str(url_decode2bytes(src))
}

type! CorruptInputError String derive(Show)

fn decode_quantum(
  decode_map : FixedArray[Byte],
  dst : FixedArray[Byte],
  src : FixedArray[Byte],
  si : Int
) -> (Int, Int)!CorruptInputError {
  let dbuf : FixedArray[Byte] = FixedArray::make(4, b'\x00')
  let mut dlen = 4
  let mut si = si
  for j = 0; j < 4; j = j + 1 {
    if src.length() == si {
      if j == 0 {
        return (si, 0)
      }
      let pos = si - j
      raise CorruptInputError("illegal base64 data at input byte \{pos}")
    }
    let in_byte = src[si]
    si += 1
    let out = decode_map[in_byte.to_int()]
    if out != b'\xff' {
      dbuf[j] = out
      continue
    }
    if in_byte == b'\x0a' || in_byte == b'\x0d' {
      continue j - 1
    }
    if in_byte != pad_char {
      let pos = si - 1
      raise CorruptInputError("expected pad characted at input byte \{pos}")
    }

    // We've reached the end and there's padding
    if j == 0 || j == 1 {
      let pos = si - 1
      raise CorruptInputError("incorrect padding at input byte \{pos}")
    }
    if j == 2 {
      // "==" is expected, the first "=" is already consumed.
      // skip over newlines
      for ; si < src.length() && (src[si] == b'\x0a' || src[si] == b'\x0d'); {
        si += 1
      }
      if si == src.length() {
        // not enough padding
        let pos = src.length()
        raise CorruptInputError("not enough padding at \{pos}")
      }
      if src[si] != pad_char {
        // incorrect padding
        let pos = si - 1
        raise CorruptInputError("incorrect padding at \{pos}")
      }
      si += 1
    }

    // skip over newlines
    for ; si < src.length() && (src[si] == b'\x0a' || src[si] == b'\x0d'); {
      si += 1
    }
    if si < src.length() {
      // trailing garbage
      raise CorruptInputError("trailing garbage at \{si}")
    }
    dlen = j
    break
  }

  // Convert 4x 6bit source bytes into 3 bytes
  let val = (dbuf[0].to_uint() << 18) |
    (dbuf[1].to_uint() << 12) |
    (dbuf[2].to_uint() << 6) |
    dbuf[3].to_uint()
  dbuf[2] = (val >> 0).to_byte()
  dbuf[1] = (val >> 8).to_byte()
  dbuf[0] = (val >> 16).to_byte()
  if dlen == 4 {
    dst[2] = dbuf[2]
    dbuf[2] = b'\x00'
  }
  if dlen >= 3 {
    dst[1] = dbuf[1]
    dbuf[1] = b'\x00'
  }
  if dlen >= 2 {
    dst[0] = dbuf[0]
  }
  return (si, dlen - 1)
}

fn decode_buf(
  decode_map : FixedArray[Byte],
  dst : FixedArray[Byte],
  src : Bytes
) -> Unit!CorruptInputError {

}

fn decoded_len(n : Int) -> Int {
  n / 4 * 3
}

let std_decode_map : FixedArray[Byte] = [
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\x3e', b'\xff',
  b'\xff', b'\xff', b'\x3f', b'\x34', b'\x35', b'\x36', b'\x37', b'\x38', b'\x39',
  b'\x3a', b'\x3b', b'\x3c', b'\x3d', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\x00', b'\x01', b'\x02', b'\x03', b'\x04', b'\x05', b'\x06',
  b'\x07', b'\x08', b'\x09', b'\x0a', b'\x0b', b'\x0c', b'\x0d', b'\x0e', b'\x0f',
  b'\x10', b'\x11', b'\x12', b'\x13', b'\x14', b'\x15', b'\x16', b'\x17', b'\x18',
  b'\x19', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\x1a', b'\x1b',
  b'\x1c', b'\x1d', b'\x1e', b'\x1f', b'\x20', b'\x21', b'\x22', b'\x23', b'\x24',
  b'\x25', b'\x26', b'\x27', b'\x28', b'\x29', b'\x2a', b'\x2b', b'\x2c', b'\x2d',
  b'\x2e', b'\x2f', b'\x30', b'\x31', b'\x32', b'\x33', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff',
]

let url_decode_map : FixedArray[Byte] = [
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\x3e', b'\xff', b'\xff', b'\x34', b'\x35', b'\x36', b'\x37', b'\x38', b'\x39',
  b'\x3a', b'\x3b', b'\x3c', b'\x3d', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\x00', b'\x01', b'\x02', b'\x03', b'\x04', b'\x05', b'\x06',
  b'\x07', b'\x08', b'\x09', b'\x0a', b'\x0b', b'\x0c', b'\x0d', b'\x0e', b'\x0f',
  b'\x10', b'\x11', b'\x12', b'\x13', b'\x14', b'\x15', b'\x16', b'\x17', b'\x18',
  b'\x19', b'\xff', b'\xff', b'\xff', b'\xff', b'\x3f', b'\xff', b'\x1a', b'\x1b',
  b'\x1c', b'\x1d', b'\x1e', b'\x1f', b'\x20', b'\x21', b'\x22', b'\x23', b'\x24',
  b'\x25', b'\x26', b'\x27', b'\x28', b'\x29', b'\x2a', b'\x2b', b'\x2c', b'\x2d',
  b'\x2e', b'\x2f', b'\x30', b'\x31', b'\x32', b'\x33', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff', b'\xff',
  b'\xff', b'\xff', b'\xff', b'\xff',
]
