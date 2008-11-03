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

#import <objc/runtime.h>

#import "MessageDigest.h"
#import "MessageDigestProvider.h"

Class gDefaultMessageDigestProvider = nil;

@implementation MessageDigest

+ (void) registerProvider: (Class) provider
{
   @synchronized (self) {
      gDefaultMessageDigestProvider = provider;
   }
}

+ (id) messageDigestWithAlgorithm: (NSString*) algorithm
{
   @synchronized (self) {
      if (gDefaultMessageDigestProvider == nil) {
         gDefaultMessageDigestProvider = objc_lookUpClass(DEFAULT_MESSAGEDIGESTPROVIDER_NAME);
      }
      if (gDefaultMessageDigestProvider != nil) {
         return [[[self alloc] initWithAlgorithm: algorithm provider: gDefaultMessageDigestProvider] autorelease];
      } else {
         NSLog(@"MessageDigest does not have any providers registered.");
         return nil;
      }
   }
}

- (id) initWithAlgorithm: (NSString*) algorithm provider: (Class) provider
{
   if ((self = [super init]) != nil) {
      algorithm_ = [algorithm retain];
      provider_ = [[provider alloc] initWithAlgorithm: algorithm];
   }
   return self;
}

- (void) dealloc
{
   [algorithm_ release];
   [provider_ release];
   [super dealloc];
}

- (NSData*) digest
{
   return [provider_ digest];
}

- (MessageDigest*) updateWithData: (NSData*) data
{
   [provider_ updateWithBytes: [data bytes] length: [data length]];
   return self;
}

- (MessageDigest*) updateWithString: (NSString*) string encoding: (NSStringEncoding) encoding
{
   [self updateWithData: [string dataUsingEncoding: encoding]];
   return self;
}

- (MessageDigest*) updateWithBytes: (const void*) bytes length: (NSUInteger) length
{
   [provider_ updateWithBytes: bytes length: length];
   return self;
}

- (NSString*) algorithm
{
   return algorithm_;
}

- (NSUInteger) digestLength
{
   return [provider_ digestLength];
}

@end

#if defined(MESSAGEDIGEST_EXAMPLE)
int main(int argc, char** argv)
{
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   
   MessageDigest* messageDigest = [MessageDigest messageDigestWithAlgorithm: @"SHA1"];
   [messageDigest updateWithString: @"Hello, world!" encoding: NSASCIIStringEncoding];
   NSData* digest = [messageDigest digest];
   NSLog(@"Digest = %@", digest);
   
   return 0;
}
#endif
