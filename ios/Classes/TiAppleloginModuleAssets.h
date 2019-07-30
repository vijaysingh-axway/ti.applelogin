/**
  * ti.applelogin
  * Copyright (c) 2018-present by Appcelerator, Inc. All Rights Reserved.
  * Licensed under the terms of the Apache Public License
  * Please see the LICENSE included with this distribution for details.
  */

@interface TiAppleloginModuleAssets : NSObject {

}

- (NSData *)moduleAsset;
- (NSData *)resolveModuleAsset:(NSString*)path;

@end
