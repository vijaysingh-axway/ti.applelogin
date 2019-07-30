/**
  * ti.applelogin
  * Copyright (c) 2018-present by Appcelerator, Inc. All Rights Reserved.
  * Licensed under the terms of the Apache Public License
  * Please see the LICENSE included with this distribution for details.
  */

#import "TiAppleloginSignInButton.h"
#import "TiAppleloginSignInButtonProxy.h"

@implementation TiAppleloginSignInButton

#pragma mark Internal

- (TiAppleloginSignInButtonProxy *)signInButtonProxy
{
  return (TiAppleloginSignInButtonProxy *)[self proxy];
}

- (id)signInButton
{
  if (_signInButton == nil) {
      if (@available(iOS 13.0, *)) {
          _type = [TiUtils intValue:[self.proxy valueForUndefinedKey:@"type"] def:ASAuthorizationAppleIDButtonTypeSignIn];
          _style = [TiUtils intValue:[self.proxy valueForUndefinedKey:@"style"] def:ASAuthorizationAppleIDButtonStyleWhite];
          _signInButton = [ASAuthorizationAppleIDButton buttonWithType:_type style:_style];
          [self addSubview:_signInButton];
          [_signInButton addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

      } else {
      }
  }
  return _signInButton;
}

- (NSInteger)type
{
  return _type;
}

- (NSInteger)style
{
  return _style;
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
  [TiUtils setView:[self signInButton] positionRect:bounds];
}

- (void)didTouchUpInside:(id)sender
{
  if ([[self signInButtonProxy] _hasListeners:@"click"]) {
    [[self signInButtonProxy] fireEvent:@"click" withObject:nil];
  }
}

- (BOOL)hasTouchableListener
{
  return YES;
}

- (void)setCornerRadius_:(NSNumber *)radius
{
    if (@available(iOS 13.0, *)) {
        ((ASAuthorizationAppleIDButton *)[self signInButton]).cornerRadius = [TiUtils floatValue:radius];
    } else {
    }
}

- (CGFloat)cornerRadius
{
if (@available(iOS 13.0, *)) {
    return _signInButton.cornerRadius;
} else {
    return 0.0;
}
}

@end
