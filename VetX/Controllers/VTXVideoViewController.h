//
//  VTXVideoViewController.h
//  VetX
//
//  Created by YulianMobile on 3/28/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Consultation.h"
@class TWCIncomingInvite;
@class TwilioConversationsClient;

@interface VTXVideoViewController : UIViewController

- (instancetype)initWithToken:(NSString *)token;

- (instancetype)initWithToken:(NSString *)token invitee:(NSString *)inviteeIdentity;

@property (nonatomic, copy) NSString* currentIdentity;
@property (nonatomic, strong) NSString *inviteeIdentity;
@property (nonatomic, strong) TWCIncomingInvite *incomingInvite;
@property (nonatomic, strong) Consultation *consultation;
//@property (nonatomic, strong) TwilioConversationsClient *client;

@end
