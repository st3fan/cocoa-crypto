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

#import "RandomGenerator.h"

Class gDefaultRandomGeneratorProvider = nil;

@implementation RandomGenerator

+ (void) registerProvider: (Class) provider
{
   @synchronized (self) {
      gDefaultRandomGeneratorProvider = provider;
   }
}

+ (id) randomGenerator
{
   @synchronized (self) {
      if (gDefaultRandomGeneratorProvider == nil) {
         gDefaultRandomGeneratorProvider = objc_lookUpClass(DEFAULT_RANDOMGENERATORPROVIDER_NAME);
      }
      if (gDefaultRandomGeneratorProvider != nil) {
         return [[[self alloc] initWithProvider: gDefaultRandomGeneratorProvider] autorelease];
      } else {
         NSLog(@"RandomGenerator does not have any providers registered.");
         return nil;
      }
   }
   return nil;
}

- (id) initWithProvider: (Class) provider
{
   if ((self = [super init]) != nil) {
      provider_ = [[provider alloc] init];
   }
   return self;
}

- (void) dealloc
{
   [provider_ release];
   [super dealloc];
}

- (long) randomLong
{
   return [provider_ randomLong];
}

@end
