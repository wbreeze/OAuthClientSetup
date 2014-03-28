//
//  OACSAuthOpRK.h
//
//  Created by Douglas Lovell on 3/27/14.
//  Copyright (c) 2014 Telegraphy Interactive. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>
#import "OACSAuthClient.h"
#import "RKObjectManager.h"

@interface OACSAuthOpRK : NSObject <AuthOp>

@property (strong, readonly) RKObjectRequestOperation *operation;
@property (strong, readonly) RKMappingResult *mappingResult;

- initWithObjectManager:(RKObjectManager *)objectManager forPath:(NSString *)path;

@end
