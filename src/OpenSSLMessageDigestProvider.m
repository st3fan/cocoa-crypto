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

#import "OpenSSLMessageDigestProvider.h"
#import "MessageDigest.h"

@implementation OpenSSLMessageDigestProvider

+ (void) initialize
{
   OpenSSL_add_all_digests();
}

- (id) initWithAlgorithm: (NSString*) algorithm
{
   const EVP_MD* md = EVP_get_digestbyname([algorithm cStringUsingEncoding: NSASCIIStringEncoding]);
   if (md == NULL) {
      return nil;
   }

   if ((self = [super init]) != nil) {
      md_ = md;
      EVP_MD_CTX_init(&context_);
      EVP_DigestInit_ex(&context_, md_, NULL);
   }
   
   return self;
}

- (void) updateWithBytes: (const void*) bytes length: (NSUInteger) length
{
   EVP_DigestUpdate(&context_, bytes, length);
}

- (NSData*) digest
{
   unsigned char digest_bytes[EVP_MAX_MD_SIZE];
   unsigned int digest_length;
   
   EVP_DigestFinal_ex(&context_, digest_bytes, &digest_length);
   return [NSData dataWithBytes: digest_bytes length: digest_length];
}

- (NSUInteger) digestLength
{
   return EVP_MD_size(md_);
}

- (void) dealloc
{
   EVP_MD_CTX_cleanup(&context_);
   [super dealloc];
}

@end
