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

#import "Mac.h"
#import "MacProvider.h"

Class gDefaultMacProvider = nil;

@implementation Mac

+ (void) registerProvider: (Class) provider
{
   @synchronized (self) {
      gDefaultMacProvider = provider;
   }
}

+ (id) macWithAlgorithm: (NSString*) algorithm key: (NSData*) key
{
   @synchronized (self) {
      if (gDefaultMacProvider == nil) {
         gDefaultMacProvider = objc_lookUpClass(DEFAULT_MACPROVIDER_NAME);
      }
      if (gDefaultMacProvider != nil) {
         return [[[self alloc] initWithAlgorithm: algorithm key: key provider: gDefaultMacProvider]
            autorelease];
      } else {
         NSLog(@"Mac does not have any providers registered.");
         return nil;
      }
   }
   return nil;
}

- (id) initWithAlgorithm: (NSString*) algorithm key: (NSData*) key provider: (Class) provider
{
   if ((self = [super init]) != nil) {
      algorithm_ = [algorithm retain];
      key_ = [key retain];
      provider_ = [[provider alloc] initWithAlgorithm: algorithm key: key];
   }
   return self;
}

- (void) dealloc
{
   [key_ release];
   [algorithm_ release];
   [provider_ release];
   [super dealloc];
}

- (NSData*) digest
{
   return [provider_ digest];
}

- (Mac*) updateWithData: (NSData*) data
{
   [provider_ updateWithBytes: [data bytes] length: [data length]];
   return self;
}

- (Mac*) updateWithString: (NSString*) string encoding: (NSStringEncoding) encoding
{
   [self updateWithData: [string dataUsingEncoding: encoding]];
   return self;
}

- (Mac*) updateWithBytes: (const void*) bytes length: (NSUInteger) length
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

#if defined(MAC_EXAMPLE)
int main(int argc, char** argv)
{
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   
   Mac* mac = [Mac macWithAlgorithm: @"SHA1" key: [@"Secret" dataUsingEncoding: NSASCIIStringEncoding]];
   [mac updateWithString: @"Hello, world!" encoding: NSASCIIStringEncoding];
   NSData* digest = [mac digest];
   NSLog(@"Digest = %@", digest);
   
   return 0;
}
#endif
