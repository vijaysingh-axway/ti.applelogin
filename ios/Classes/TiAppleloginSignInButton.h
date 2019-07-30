/**
  * ti.applelogin
  * Copyright (c) 2018-present by Appcelerator, Inc. All Rights Reserved.
  * Licensed under the terms of the Apache Public License
  * Please see the LICENSE included with this distribution for details.
  */
#import <AuthenticationServices/AuthenticationServices.h>
#import "TiUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TiAppleloginSignInButton : TiUIView {
#if IS_SDK_IOS_13
    ASAuthorizationAppleIDButton *_signInButton;
#endif
    NSInteger _type;
    NSInteger _style;
}

- (NSInteger)type;
- (NSInteger)style;
- (CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
