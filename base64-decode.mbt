///|
/// This package is based on the Go implementation found here:
/// https://cs.opensource.google/go/go/+/master:src/encoding/base64/base64.go
/// which has the copyright notice:
/// Copyright 2009 The Go Authors. All rights reserved.
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file.
pub(all) type! CorruptInputError String derive(Show)

///|
/// `std_decode2bytes` base64-decodes the provided bytes using Standard encoding.
/// Setting `no_padding=true` is used for raw decoding.
///
/// Note that standard encoding uses `+` and `/` characters whereas URL encoding uses `-` and `_`.
///
/// Examples:
/// ```
/// let b = "+/ Hello, 世界! 🌍"
/// inspect!(std_decode2bytes!("Ky8gSGVsbG8sIOS4lueVjCEg8J+MjQ==") |> bytes2str(), content=b)
/// inspect!(std_decode2bytes!("Ky8gSGVsbG8sIOS4lueVjCEg8J+MjQ", no_padding=true) |> bytes2str(), content=b)
/// ```
pub fn std_decode2bytes(
  src : String,
  no_padding~ : Bool = false
) -> Bytes!CorruptInputError {
  if src.length() == 0 {
    return Bytes::from_array([])
  }
  let buf = FixedArray::make(decoded_len(src.length(), no_padding), b'\x00')
  let src = FixedArray::from_iter(str2bytes(src).iter())
  let n = decode_buf!(std_decode_map, buf, src, no_padding)
  Bytes::from_iter(buf.iter().take(n))
}

///|
/// `std_decode2str` base64-decodes the provided bytes using Standard encoding and returns a String.
/// Setting `no_padding=true` is used for raw decoding.
///
/// Note that standard encoding uses `+` and `/` characters whereas URL encoding uses `-` and `_`.
///
/// Examples:
/// ```
/// let b = "+/ Hello, 世界! 🌍"
/// inspect!(std_decode2str!("Ky8gSGVsbG8sIOS4lueVjCEg8J+MjQ=="), content=b)
/// inspect!(std_decode2str!("Ky8gSGVsbG8sIOS4lueVjCEg8J+MjQ", no_padding=true), content=b)
/// ```
pub fn std_decode2str(
  src : String,
  no_padding~ : Bool = false
) -> String!CorruptInputError {
  bytes2str(std_decode2bytes!(src, no_padding~))
}

///|
/// `url_decode2bytes` base64-decodes the provided bytes using URL encoding.
/// Setting `no_padding=true` is used for raw decoding.
///
/// Note that standard encoding uses `+` and `/` characters whereas URL encoding uses `-` and `_`.
///
/// Examples:
/// ```
/// let b = "+/ Hello, 世界! 🌍"
/// inspect!(url_decode2bytes!("Ky8gSGVsbG8sIOS4lueVjCEg8J-MjQ==") |> bytes2str(), content=b)
/// inspect!(url_decode2bytes!("Ky8gSGVsbG8sIOS4lueVjCEg8J-MjQ", no_padding=true) |> bytes2str(), content=b)
/// ```
pub fn url_decode2bytes(
  src : String,
  no_padding~ : Bool = false
) -> Bytes!CorruptInputError {
  if src.length() == 0 {
    return Bytes::from_array([])
  }
  let buf = FixedArray::make(decoded_len(src.length(), no_padding), b'\x00')
  let src = FixedArray::from_iter(str2bytes(src).iter())
  let n = decode_buf!(url_decode_map, buf, src, no_padding)
  Bytes::from_iter(buf.iter().take(n))
}

///|
/// `url_decode2str` base64-decodes the provided bytes using URL encoding and returns a String.
/// Setting `no_padding=true` is used for raw decoding.
///
/// Note that standard encoding uses `+` and `/` characters whereas URL encoding uses `-` and `_`.
///
/// Examples:
/// ```
/// let b = "+/ Hello, 世界! 🌍"
/// inspect!(url_decode2str!("Ky8gSGVsbG8sIOS4lueVjCEg8J-MjQ=="), content=b)
/// inspect!(url_decode2str!("Ky8gSGVsbG8sIOS4lueVjCEg8J-MjQ", no_padding=true), content=b)
/// ```
pub fn url_decode2str(
  src : String,
  no_padding~ : Bool = false
) -> String!CorruptInputError {
  bytes2str(url_decode2bytes!(src, no_padding~))
}

///|
fn decode_quantum(
  decode_map : FixedArray[Byte],
  dst : FixedArray[Byte],
  dst_offset : Int,
  src : FixedArray[Byte],
  si : Int,
  decode_pad_char : Byte,
  no_padding : Bool
) -> (Int, Int)!CorruptInputError {
  let dbuf : FixedArray[Byte] = FixedArray::make(4, b'\x00')
  let mut dlen = 4
  let mut si = si
  for j = 0; j < 4; j = j + 1 {
    if src.length() == si {
      if j == 0 {
        return (si, 0)
      }
      if j == 1 || not(no_padding) {
        let pos = si - j
        raise CorruptInputError("illegal base64 data at input byte \{pos}")
      }
      dlen = j
      break
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
    if in_byte != decode_pad_char {
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
      if src[si] != decode_pad_char {
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
    dst[dst_offset + 2] = dbuf[2]
    dbuf[2] = b'\x00'
  }
  if dlen >= 3 {
    dst[dst_offset + 1] = dbuf[1]
    dbuf[1] = b'\x00'
  }
  if dlen >= 2 {
    dst[dst_offset + 0] = dbuf[0]
  }
  return (si, dlen - 1)
}

///|
fn decode_buf(
  decode_map : FixedArray[Byte],
  dst : FixedArray[Byte],
  src : FixedArray[Byte],
  no_padding : Bool
) -> Int!CorruptInputError {
  if src.length() == 0 {
    return 0
  }
  let decode_pad_char = if no_padding { b'\xff' } else { pad_char }
  //
  let mut si = 0
  let mut n = 0
  for ; src.length() - si >= 4 && dst.length() - n >= 4; {
    let (dn, ok) = assemble32(
      decode_map[src[si + 0].to_int()],
      decode_map[src[si + 1].to_int()],
      decode_map[src[si + 2].to_int()],
      decode_map[src[si + 3].to_int()],
    )
    if ok {
      be_put_uint32(dst, n, dn)
      n += 3
      si += 4
    } else {
      let pair = decode_quantum!(
        decode_map, dst, n, src, si, decode_pad_char, no_padding,
      )
      si = pair.0
      let ninc = pair.1
      n += ninc
    }
  }
  for ; si < src.length(); {
    let pair = decode_quantum!(
      decode_map, dst, n, src, si, decode_pad_char, no_padding,
    )
    si = pair.0
    let ninc = pair.1
    n += ninc
  }
  n
}

///|
fn be_put_uint32(b : FixedArray[Byte], offset : Int, value : UInt) -> Unit {
  b[offset + 3] = (value & 0xff).to_byte()
  b[offset + 2] = ((value >> 8) & 0xff).to_byte()
  b[offset + 1] = ((value >> 16) & 0xff).to_byte()
  b[offset] = ((value >> 24) & 0xff).to_byte()
}

// assemble32 assembles 4 base64 digits into 3 bytes.
// Each digit comes from the decode map, and will be 0xff
// if it came from an invalid character.
///|
fn assemble32(n1 : Byte, n2 : Byte, n3 : Byte, n4 : Byte) -> (UInt, Bool) {
  // Check that all the digits are valid. If any of them was 0xff, their
  // bitwise OR will be 0xff.
  if (n1 | (n2 | (n3 | n4))) == b'\xff' {
    return (0, false)
  }
  (
    (n1.to_uint() << 26) |
    ((n2.to_uint() << 20) | ((n3.to_uint() << 14) | (n4.to_uint() << 8))),
    true,
  )
}

///|
fn decoded_len(n : Int, no_padding : Bool) -> Int {
  if no_padding {
    return n / 4 * 3 + n % 4 * 6 / 8
  }
  n / 4 * 3
}

///|
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

///|
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
