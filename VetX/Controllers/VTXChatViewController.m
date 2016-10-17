//
//  VTXChatViewController.m
//  VetX
//
//  Created by YulianMobile on 2/26/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXChatViewController.h"
#import "Constants.h"
#import <JSQMessagesViewController/JSQMessages.h> 
#import "VTXChatManager.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "QuestionManager.h"
#import "UserManager.h"
#import "IQKeyboardManager.h"
@import Firebase;

@interface VTXChatViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageView;


@end

@implementation VTXChatViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setExclusiveTouch:YES];
    [leftButton setFrame:CGRectMake(0, 0, 32, 32)];
    [leftButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"End" style:UIBarButtonItemStylePlain target:self action:@selector(endChatAlert)];
    [right setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:left];
    [self.navigationItem setRightBarButtonItem:right];

    [self.navigationItem setTitle:@"Chat"];
    
    self.showLoadEarlierMessagesHeader = NO;
    self.messages = [[NSMutableArray alloc] init];
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    
    [self setupBubbles];
    [self loadInitData];
    [self observerMessages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Settings Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"Chat" withParameters:nil timed:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
//    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    [self observerTyping];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClicked {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endChatAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"End 1-on-1?" message:@"This will permanently end this consultation. Are you sure you want to end it?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction *give = [UIAlertAction actionWithTitle:@"End" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @try {
            [self endChat];
        } @catch (NSException *exception) {
            NSLog(@"Error to end consultation: %@", exception);
        } @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self backButtonClicked];
            });
        }
    }];
    [alert addAction:ok];
    [alert addAction:give];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)endChat {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"End Chat"
                                                           label:@"End Chat"
                                                           value:nil] build]];
    [Flurry logEvent:@"End Chat"];
    @try {
        if (self.groupID) {
            [[QuestionManager defaultManager] endConsultation:self.groupID withUser:[[UserManager defaultManager] currentUserID] andSuccess:^(BOOL finished) {
                
            } andError:^(NSError *error) {
                
            }];
        }
    } @catch (NSException *exception) {
        [self backButtonClicked];
    }     
}

- (void)setupBubbles {
    JSQMessagesBubbleImageFactory *bubbleImageFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageView = [bubbleImageFactory outgoingMessagesBubbleImageWithColor:ORANGE_THEME_COLOR];
    self.incomingBubbleImageView = [bubbleImageFactory incomingMessagesBubbleImageWithColor:GREY_COLOR];
}

- (void)loadInitData {
    [[VTXChatManager defaultManager] queryMessageHistory:self.groupID completion:^(BOOL success, NSDictionary *result, NSError *error) {
        if (success && result) {
            NSLog(@"load init messages: %@", result);
        }
    }];
}

- (void)observerMessages {
    [[VTXChatManager defaultManager] observeNewMessage:self.groupID completion:^(BOOL success, NSDictionary *result, NSError *error) {
        if (success && result) {
            [self addNewMessage:result];
        }
    }];
}

- (void)addNewMessage:(NSDictionary *)result {
//    NSArray *messages = [result allValues];
        //!!!: Define response model here
    NSString *senderId = result[@"senderID"];
    NSString *textMessage = result[@"message"];
    NSString *senderName = result[@"displayName"];
    NSString *imageURL = result[@"imageURL"];
    if ([imageURL isEqualToString:@""]) {
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                                 senderDisplayName:senderName
                                                              date:[NSDate date]
                                                              text:textMessage];
        [self.messages addObject:message];
        [self finishSendingMessageAnimated:YES];
    } else if ([imageURL hasPrefix:@"gs://"] || [imageURL hasPrefix:@"https://"]) {
//        FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:imageURL];
//        NSURL *url = [storageRef getDownloadURL];
        [[[FIRStorage storage] referenceForURL:imageURL] dataWithMaxSize:INT64_MAX completion:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
                JSQMessage *photoMessage = [JSQMessage messageWithSenderId:senderId
                                                               displayName:senderName
                                                                     media:photoItem];
                [self.messages addObject:photoMessage];
                [self finishSendingMessageAnimated:YES];
            }
        }];
        
    }
}

- (void)observerTyping {
    
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_press"
                                                           label:@"close_chat"
                                                           value:nil] build]];
    [Flurry endTimedEvent:@"Chat" withParameters:nil];
    [self.delegateModal didDismissJSQDemoViewController:self];
}


- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    if (self.isFinished) {
        [self consultationFinishedAlert];
        return;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Send Message"
                                                           label:@"Send Message"
                                                           value:nil] build]];
    [Flurry logEvent:@"Send Message"];
    
    [[VTXChatManager defaultManager] sendMessage:text imageURL:@"" sender:senderId name:senderDisplayName group:self.groupID completion:^(BOOL success, NSDictionary *result, NSError *error) {
        [self finishSendingMessageAnimated:YES];
        [self sendMessagePushNotification];
    }];
    
    
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    if (self.isFinished) {
        [self consultationFinishedAlert];
        return;
    }
    [self.view endEditing:YES];
    UIAlertController *addImageOptions = [UIAlertController alertControllerWithTitle:@"Send Image" message:@"Send an image for this consultation" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *camera=[[UIImagePickerController alloc]init];
            
            [camera setSourceType:UIImagePickerControllerSourceTypeCamera];
            camera.allowsEditing=YES;
            [camera setDelegate:self];
            
            [self presentViewController:camera animated:YES completion:nil];
        }
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *photoLibrary=[[UIImagePickerController alloc]init];
            [photoLibrary setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            photoLibrary.allowsEditing=YES;
            [photoLibrary setDelegate:self];
            [self presentViewController:photoLibrary animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancenl = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [addImageOptions dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [addImageOptions addAction:camera];
    [addImageOptions addAction:library];
    [addImageOptions addAction:cancenl];
    [self presentViewController:addImageOptions animated:YES completion:^{
    }];
}

- (void)consultationFinishedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Consultation has been finished" message:@"Sorry, this consultation has been finished, please start a new one if needed" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)sendMessagePushNotification {
    if (self.receiverID == nil || [self.receiverID isEqualToString:@""] || self.senderId == nil || [self.senderId isEqualToString:@""]) {
        return;
    }
    @try {
        [[UserManager defaultManager] sendNotificationFrom:self.senderId to:self.receiverID completion:^(BOOL finished) {
        
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception to send push notification in chat: %@", exception);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Send Image Message"
                                                           label:@"Send Image Message"
                                                           value:nil] build]];
    [Flurry logEvent:@"Send Image Message"];
    [[VTXChatManager defaultManager] sendImageMessage:imageData sender:self.senderId name:self.senderDisplayName group:self.groupID completion:^(BOOL success, NSDictionary *result, NSError *error) {
        if (success) {
            [self finishSendingMessageAnimated:YES];
            [self sendMessagePushNotification];
        }
    }];
    
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
//            [self.demoData addPhotoMediaMessage];
            break;
            
        case 1:
//        {
//            __weak UICollectionView *weakView = self.collectionView;
            
//            [self.demoData addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
//        }
            break;
            
        case 2:
//            [self.demoData addVideoMediaMessage];
            break;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessageAnimated:YES];
}



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageView;
    }
    
    return self.incomingBubbleImageView;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
//    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
//    if ([message.senderId isEqualToString:self.senderId]) {
//        if (![NSUserDefaults outgoingAvatarSetting]) {
//            return nil;
//        }
//    }
//    else {
//        if (![NSUserDefaults incomingAvatarSetting]) {
//            return nil;
//        }
//    }
    
    return nil;
//    return [self.demoData.avatars objectForKey:message.senderId];
}

//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
//    if (indexPath.item % 3 == 0) {
//        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
//        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
//    }
    
//    return nil;
//}

//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//{
//    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
//    
//    /**
//     *  iOS7-style sender name labels
//     */
//    if ([message.senderId isEqualToString:self.senderId]) {
//        return nil;
//    }
//    
//    if (indexPath.item - 1 > 0) {
//        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
//        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
//            return nil;
//        }
//    }
//    
//    /**
//     *  Don't specify attributes to use the defaults.
//     */
//    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
//}

//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
//        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
//                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

//- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
//                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
//    if (indexPath.item % 3 == 0) {
//        return kJSQMessagesCollectionViewCellLabelHeightDefault;
//    }
//    
//    return 0.0f;
//}

//- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
//                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//{
//    /**
//     *  iOS7-style sender name labels
//     */
//    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
//    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
//        return 0.0f;
//    }
//    
//    if (indexPath.item - 1 > 0) {
//        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
//        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
//            return 0.0f;
//        }
//    }
//    
//    return kJSQMessagesCollectionViewCellLabelHeightDefault;
//}

//- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
//                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0.0f;
//}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

@end
