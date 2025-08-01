# gmlewis/base64
[![check](https://github.com/gmlewis/moonbit-base64/actions/workflows/check.yml/badge.svg)](https://github.com/gmlewis/moonbit-base64/actions/workflows/check.yml)

This is a simple base64 encoder based on Go's implementation:
https://cs.opensource.google/go/go/+/master:src/encoding/base64/base64.go
which has the copyright notice:

```
// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
```

The UTF-16 / UTF-8 encoder/decoders are provided with permission by
@peter-jerry-ye from this repo: https://github.com/peter-jerry-ye/jstream

## Status

The code has been updated to support compiler:

```bash
$ moon version --all
moon 0.1.20250724 (2797252 2025-07-24) ~/.moon/bin/moon
moonc v0.6.22 ~/.moon/bin/moonc
moonrun 0.1.20250724 (2797252 2025-07-24) ~/.moon/bin/moonrun
```
