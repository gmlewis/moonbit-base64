///|
fn main {
  let my_string : String = "Some example text"
  println("my_string: '\{my_string}'")
  println(@base64.std_encode2str(@base64.str2bytes(my_string).to_fixedarray()))
  let my_bytes : Bytes = "Some example text" // Or get a Bytes variable through other means
  println(@base64.std_encode2str(my_bytes.to_fixedarray()))

  //
  let msg_bytes : Bytes = "U29tZSBleGFtcGxlIHRleHQ="
  let msg = try {
    @base64.std_decode2str!(@base64.bytes2str(msg_bytes))
  } catch {
    _ => abort("fail")
  }
  println("msg from bytes: '\{msg}'")
  let msg_string : String = "U29tZSBleGFtcGxlIHRleHQ="
  let msg = try {
    @base64.std_decode2str!(msg_string)
  } catch {
    _ => abort("fail")
  }
  println("msg from string: '\{msg}'")
}
