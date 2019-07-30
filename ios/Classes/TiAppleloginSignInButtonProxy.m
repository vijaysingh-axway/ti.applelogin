/**
  * ti.applelogin
  * Copyright (c) 2018-present by Appcelerator, Inc. All Rights Reserved.
  * Licensed under the terms of the Apache Public License
  * Please see the LICENSE included with this distribution for details.
  */


#import "TiAppleloginSignInButtonProxy.h"
#import "TiAppleloginSignInButton.h"

@implementation TiAppleloginSignInButtonProxy

- (TiAppleloginSignInButton *)signInButton
{
  return (TiAppleloginSignInButton *)self.view;
}

- (NSNumber *)type
{
    return NUMINT([[self signInButton] type]);
}

- (NSNumber *)style
{
   return NUMINT([[self signInButton] style]);
}

- (NSNumber *)cornerRadius
{
   return NUMFLOAT([[self signInButton] cornerRadius]);
}
@end
