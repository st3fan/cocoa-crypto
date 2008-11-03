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

#import "CommonCryptoMacProvider.h"
#import "Mac.h"

NSMutableDictionary* sCommonCryptoHmacAlgorithms;

@implementation CommonCryptoMacProvider

+ (void) initialize
{
   sCommonCryptoHmacAlgorithms = [[NSMutableDictionary dictionary] retain];
   [sCommonCryptoHmacAlgorithms setObject: [NSNumber numberWithInt: kCCHmacAlgMD5] forKey: @"MD5"];
   [sCommonCryptoHmacAlgorithms setObject: [NSNumber numberWithInt: kCCHmacAlgSHA1] forKey: @"SHA1"];
   [sCommonCryptoHmacAlgorithms setObject: [NSNumber numberWithInt: kCCHmacAlgSHA224] forKey: @"SHA224"];
   [sCommonCryptoHmacAlgorithms setObject: [NSNumber numberWithInt: kCCHmacAlgSHA256] forKey: @"SHA256"];
   [sCommonCryptoHmacAlgorithms setObject: [NSNumber numberWithInt: kCCHmacAlgSHA384] forKey: @"SHA384"];   
}

- (id) initWithAlgorithm: (NSString*) algorithm key: (NSData*) key
{
   NSNumber* algorithmCode = [sCommonCryptoHmacAlgorithms valueForKey: algorithm];
   if (algorithmCode = nil) {
      return nil;
   }

   if ((self = [super init]) != nil) {
      algorithm_ = (CCHmacAlgorithm) [algorithmCode intValue];
      CCHmacInit(&context_, algorithm_, [key bytes], [key length]);
   }
   
   return self;
}

- (void) updateWithBytes: (const void*) bytes length: (NSUInteger) length
{
   CCHmacUpdate(&context_, bytes, length);
}

- (NSData*) digest
{
   unsigned char digest_bytes[512];
   unsigned int digest_length;
   
   CCHmacFinal(&context_, digest_bytes);
   
   switch (algorithm_) {
      case kCCHmacAlgMD5:
         digest_length = CC_MD5_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA1:
         digest_length = CC_SHA1_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA224:
         digest_length = CC_SHA224_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA256:
         digest_length = CC_SHA256_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA384:
         digest_length = CC_SHA384_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA512:
         digest_length = CC_SHA512_DIGEST_LENGTH;
         break;
   }

   return [NSData dataWithBytes: digest_bytes length: digest_length];
}

- (NSUInteger) digestLength
{
   NSUInteger digest_length = 0;

   switch (algorithm_) {
      case kCCHmacAlgMD5:
         digest_length = CC_MD5_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA1:
         digest_length = CC_SHA1_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA224:
         digest_length = CC_SHA224_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA256:
         digest_length = CC_SHA256_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA384:
         digest_length = CC_SHA384_DIGEST_LENGTH;
         break;
      case kCCHmacAlgSHA512:
         digest_length = CC_SHA512_DIGEST_LENGTH;
         break;
   }

   return digest_length;
}

- (void) dealloc
{
   [super dealloc];
}

@end
