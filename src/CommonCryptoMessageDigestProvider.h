/*
 * (C) Copyright 2008, Stefan Arentz, Arentz Consulting.
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <CommonCrypto/CommonDigest.h>

#import <Foundation/Foundation.h>
#import "MessageDigestProvider.h"

// If the digest code in CommonCrypto was designed as well as the HMAC code
// then all this stuff would not have been required.

union CommonKryptoContext {
      CC_MD2_CTX md2;
      CC_MD4_CTX md4;
      CC_MD5_CTX md5;
      CC_SHA1_CTX sha1;
      CC_SHA256_CTX sha224;
      CC_SHA256_CTX sha256;
      CC_SHA512_CTX sha384;
      CC_SHA512_CTX sha512;
};

enum {
   CommonKryptoDigestAlgoMD2,
   CommonKryptoDigestAlgoMD4,
   CommonKryptoDigestAlgoMD5,
   CommonKryptoDigestAlgoSHA1,
   CommonKryptoDigestAlgoSHA224,
   CommonKryptoDigestAlgoSHA256,
   CommonKryptoDigestAlgoSHA384,
   CommonKryptoDigestAlgoSHA512
};

@interface CommonCryptoMessageDigestProvider : MessageDigestProvider {
   union CommonKryptoContext context_;
   int algorithm_;
}
- (id) initWithAlgorithm: (NSString*) algorithm;
- (void) updateWithBytes: (const void*) bytes length: (NSUInteger) length;
- (NSData*) digest;
- (NSUInteger) digestLength;
@end
