//
//  VTXChatViewController.h
//  VetX
//
//  Created by YulianMobile on 2/26/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@class VTXChatViewController;

@protocol VTXChatViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(VTXChatViewController *)vc;

@end

@interface VTXChatViewController : JSQMessagesViewController

@property (weak, nonatomic) id<VTXChatViewControllerDelegate> delegateModal;

@property (strong, nonatomic) NSString *groupID;
@property (strong, nonatomic) NSString *receiverID;
@property (assign, nonatomic) BOOL isFinished;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
