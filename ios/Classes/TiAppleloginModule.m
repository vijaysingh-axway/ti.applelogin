/**
  * ti.applelogin
  * Copyright (c) 2018-present by Appcelerator, Inc. All Rights Reserved.
  * Licensed under the terms of the Apache Public License
  * Please see the LICENSE included with this distribution for details.
  */

#import "TiAppleloginModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#if IS_SDK_IOS_13
@interface TiAppleloginModule() <ASAuthorizationControllerDelegate>
@end
#endif

@implementation TiAppleloginModule

#pragma mark Internal

// This is generated for your module, please do not change it
- (id)moduleGUID
{
  return @"8ee9c2a8-3b34-432a-a171-82ef66ec867e";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
  return @"ti.applelogin";
}

#pragma mark Lifecycle

- (void)startup
{
  [super startup];
  DebugLog(@"[DEBUG] %@ loaded", self);
}

#pragma mark Utility

- (NSArray *)getAuthorizationScopes:(id)args
{
    ENSURE_TYPE_OR_NIL(args, NSArray);
    if (@available(iOS 13.0, *)) {
        NSMutableArray *authorizationScopes = [NSMutableArray array];
        for (ASAuthorizationScope scope in args) {
            ENSURE_TYPE(scope, NSString);
            [authorizationScopes addObject:scope];
        }
        return authorizationScopes;
    } else {
        NSLog(@"[ERROR] Attempting to use iOS 13+ API in older iOS versions!");
        return @[];
    }
}

#pragma Public APIs

- (void)credentialState:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    NSString *userId = args[@"userId"];
    ENSURE_TYPE(userId, NSString);
    
    KrollCallback *callback = [args valueForKey:@"callback"];
    if(![callback isKindOfClass:[KrollCallback class]]) {
        NSLog(@"[WARN] ti.applelogin: The parameter `callback` in `login` must be a function.");
        return;
    }
    
    [self replaceValue:callback forKey:@"callback" notification:NO];

    if (@available(iOS 13.0, *)) {
        NSString *userId = userId;
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        [appleIDProvider getCredentialStateForUserID:userId completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            NSDictionary *event = @{
                @"error": error ? error.localizedDescription : @"",
                @"credentialState": NUMINTEGER(credentialState)
            };
            [self fireCallback:@"callback" withArg:event withSource:self];
        }];
    } else {
        NSLog(@"[ERROR] Attempting to use iOS 13+ API in older iOS versions!");
    }
}

- (void)login:(id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    if (@available(iOS 13.0, *)) {
        
        KrollCallback *callback = [args valueForKey:@"callback"];
        if(![callback isKindOfClass:[KrollCallback class]]) {
            NSLog(@"[WARN] ti.applelogin: The parameter `callback` in `login` must be a function.");
            return;
        }
        
        [self replaceValue:callback forKey:@"callback" notification:NO];
        
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        
        appleIDRequest.requestedScopes = [self getAuthorizationScopes:[args valueForKey:@"authorizationScopes"]];;
        
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        authorizationController.delegate = self;
        
        [authorizationController performRequests];
    } else {
        NSLog(@"[ERROR] Attempting to use iOS 13+ API in older iOS versions!");
    }
}


#pragma mark ASAuthorizationControllerDelegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error   API_AVAILABLE(ios(13.0)){
    NSDictionary *event = @{
        @"error": error.localizedDescription,
        @"success": @NO
    };
    [self fireCallback:@"callback" withArg:event withSource:self];
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSPersonNameComponents *name = credential.fullName;
        NSDictionary *event = @{
            @"success": @YES,
            @"user": credential.user,
            @"identityToken": [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding],
            @"email": NULL_IF_NIL(credential.email),
            @"userStatus": NUMINTEGER(credential.realUserStatus),
            @"state": NULL_IF_NIL(credential.state),
            @"authorizationCode": [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding],
            @"name": @{
                    @"givenName": NULL_IF_NIL(name.givenName),
                    @"familyName": NULL_IF_NIL(name.familyName),
                    @"middleName": NULL_IF_NIL(name.middleName),
                    @"namePrefix": NULL_IF_NIL(name.namePrefix),
                    @"nameSuffix": NULL_IF_NIL(name.nameSuffix),
                    @"nickname": NULL_IF_NIL(name.nickname)
            }
        };
        [self fireCallback:@"callback" withArg:event withSource:self];
    }
}

MAKE_SYSTEM_PROP(USER_DETECTION_STATUS_LIKELY_REAL, ASUserDetectionStatusLikelyReal);
MAKE_SYSTEM_PROP(USER_DETECTION_STATUS_UNKNOWN, ASUserDetectionStatusUnknown);
MAKE_SYSTEM_PROP(USER_DETECTION_STATUS_UNSUPPORTED, ASUserDetectionStatusUnsupported);

#if IS_SDK_IOS_13
MAKE_SYSTEM_STR(AUTHORIZATION_SCOPE_FULLNAME, ASAuthorizationScopeFullName);
MAKE_SYSTEM_STR(AUTHORIZATION_SCOPE_EMAIL, ASAuthorizationScopeEmail);

MAKE_SYSTEM_PROP(CREDENTIAL_STATE_REVOKED, ASAuthorizationAppleIDProviderCredentialRevoked);
MAKE_SYSTEM_PROP(CREDENTIAL_STATE_AUTHORIZED, ASAuthorizationAppleIDProviderCredentialAuthorized);
MAKE_SYSTEM_PROP(CREDENTIAL_STATE_NOT_FOUNFD, ASAuthorizationAppleIDProviderCredentialNotFound);

MAKE_SYSTEM_PROP(BUTTON_TYPE_SIGNIN, ASAuthorizationAppleIDButtonTypeSignIn);
MAKE_SYSTEM_PROP(BUTTON_TYPE_CONTINUE, ASAuthorizationAppleIDButtonTypeContinue);

MAKE_SYSTEM_PROP(BUTTON_STYLE_WHITE, ASAuthorizationAppleIDButtonStyleWhite);
MAKE_SYSTEM_PROP(BUTTON_STYLE_BLACK, ASAuthorizationAppleIDButtonStyleBlack);
MAKE_SYSTEM_PROP(BUTTON_STYLE_WHITE_OUTLINE, ASAuthorizationAppleIDButtonStyleWhiteOutline);
#endif
@end
