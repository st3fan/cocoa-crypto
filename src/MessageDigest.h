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

#import <Foundation/Foundation.h>

#ifndef DEFAULT_MESSAGEDIGESTPROVIDER_NAME
# define DEFAULT_MESSAGEDIGESTPROVIDER_NAME "OpenSSLMessageDigestProvider"
#endif

@class MessageDigestProvider;

@interface MessageDigest : NSObject {
   NSString* algorithm_;
   MessageDigestProvider* provider_;
}
+ (void) registerProvider: (Class) provider;
+ (id) messageDigestWithAlgorithm: (NSString*) algorithm;
- (id) initWithAlgorithm: (NSString*) algorithm provider: (Class) provider;
- (MessageDigest*) updateWithData: (NSData*) data;
- (MessageDigest*) updateWithData: (NSData*) data;
- (MessageDigest*) updateWithString: (NSString*) string encoding: (NSStringEncoding) encoding;
- (MessageDigest*) updateWithBytes: (const void*) bytes length: (NSUInteger) length;
- (NSData*) digest;
- (NSUInteger) digestLength;
- (NSString*) algorithm;
@end
