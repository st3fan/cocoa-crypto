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

#import "CommonCryptoMessageDigestProvider.h"
#import "MessageDigest.h"

NSMutableDictionary* sCommonCryptoDigestAlgorithms;

@implementation CommonCryptoMessageDigestProvider

+ (void) initialize
{
   sCommonCryptoDigestAlgorithms = [[NSMutableDictionary dictionary] retain];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoMD2] forKey: @"MD2"];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoMD4] forKey: @"MD4"];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoMD5] forKey: @"MD5"];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoSHA1] forKey: @"SHA1"];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoSHA224] forKey: @"SHA224"];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoSHA256] forKey: @"SHA256"];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoSHA384] forKey: @"SHA384"];
   [sCommonCryptoDigestAlgorithms setObject: [NSNumber numberWithInt: CommonKryptoDigestAlgoSHA512] forKey: @"SHA512"];
}

- (id) initWithAlgorithm: (NSString*) algorithm
{
   NSNumber* algorithmCode = [sCommonCryptoDigestAlgorithms valueForKey: algorithm];
   if (algorithmCode == nil) {
      return nil;
   }

   if ((self = [super init]) != nil) {
      algorithm_ = [algorithmCode intValue];
      switch (algorithm_) {
         case CommonKryptoDigestAlgoMD2:
            CC_MD2_Init(&context_.md2);
            break;
         case CommonKryptoDigestAlgoMD4:
            CC_MD4_Init(&context_.md4);
            break;
         case CommonKryptoDigestAlgoMD5:
            CC_MD5_Init(&context_.md5);
            break;
         case CommonKryptoDigestAlgoSHA1:
            CC_SHA1_Init(&context_.sha1);
            break;
         case CommonKryptoDigestAlgoSHA224:
            CC_SHA224_Init(&context_.sha224);
            break;
         case CommonKryptoDigestAlgoSHA256:
            CC_SHA256_Init(&context_.sha256);
            break;
         case CommonKryptoDigestAlgoSHA384:
            CC_SHA384_Init(&context_.sha384);
            break;
         case CommonKryptoDigestAlgoSHA512:
            CC_SHA512_Init(&context_.sha512);
            break;
      }
   }
   
   return self;
}

- (void) updateWithBytes: (const void*) bytes length: (NSUInteger) length
{
   switch (algorithm_) {
      case CommonKryptoDigestAlgoMD2:
         CC_MD2_Update(&context_.md2, bytes, length);
         break;
      case CommonKryptoDigestAlgoMD4:
         CC_MD4_Update(&context_.md4, bytes, length);
         break;
      case CommonKryptoDigestAlgoMD5:
         CC_MD5_Update(&context_.md5, bytes, length);
         break;
      case CommonKryptoDigestAlgoSHA1:
         CC_SHA1_Update(&context_.sha1, bytes, length);
         break;
      case CommonKryptoDigestAlgoSHA224:
         CC_SHA224_Update(&context_.sha224, bytes, length);
         break;
      case CommonKryptoDigestAlgoSHA256:
         CC_SHA256_Update(&context_.sha256, bytes, length);
         break;
      case CommonKryptoDigestAlgoSHA384:
         CC_SHA384_Update(&context_.sha384, bytes, length);
         break;
      case CommonKryptoDigestAlgoSHA512:
         CC_SHA512_Update(&context_.sha512, bytes, length);
         break;
   }
}

- (NSData*) digest
{
   unsigned char digest_bytes[CC_SHA512_DIGEST_LENGTH];

   switch (algorithm_) {
      case CommonKryptoDigestAlgoMD2:
         CC_MD2_Final(digest_bytes, &context_.md2);
         break;
      case CommonKryptoDigestAlgoMD4:
         CC_MD4_Final(digest_bytes, &context_.md4);
         break;
      case CommonKryptoDigestAlgoMD5:
         CC_MD5_Final(digest_bytes, &context_.md5);
         break;
      case CommonKryptoDigestAlgoSHA1:
         CC_SHA1_Final(digest_bytes, &context_.sha1);
         break;
      case CommonKryptoDigestAlgoSHA224:
         CC_SHA224_Final(digest_bytes, &context_.sha224);
         break;
      case CommonKryptoDigestAlgoSHA256:
         CC_SHA256_Final(digest_bytes, &context_.sha256);
         break;
      case CommonKryptoDigestAlgoSHA384:
         CC_SHA384_Final(digest_bytes, &context_.sha384);
         break;
      case CommonKryptoDigestAlgoSHA512:
         CC_SHA512_Final(digest_bytes, &context_.sha512);
         break;
   }
   
   return [NSData dataWithBytes: digest_bytes length: [self digestLength]];
}

- (NSUInteger) digestLength
{
   switch (algorithm_) {
      case CommonKryptoDigestAlgoMD2:
         return CC_MD2_DIGEST_LENGTH;
      case CommonKryptoDigestAlgoMD4:
         return CC_MD4_DIGEST_LENGTH;
      case CommonKryptoDigestAlgoMD5:
         return CC_MD5_DIGEST_LENGTH;
      case CommonKryptoDigestAlgoSHA1:
         return CC_SHA1_DIGEST_LENGTH;
      case CommonKryptoDigestAlgoSHA224:
         return CC_SHA224_DIGEST_LENGTH;
      case CommonKryptoDigestAlgoSHA256:
         return CC_SHA256_DIGEST_LENGTH;
      case CommonKryptoDigestAlgoSHA384:
         return CC_SHA384_DIGEST_LENGTH;
      case CommonKryptoDigestAlgoSHA512:
         return CC_SHA512_DIGEST_LENGTH;
   }

   return 0;
}

- (void) dealloc
{
   [super dealloc];
}

@end
