//
//  VTXVideoViewController.m
//  VetX
//
//  Created by YulianMobile on 3/28/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXVideoViewController.h"
#import <TwilioConversationsClient/TwilioConversationsClient.h>
#import "CameraView.h"
#import "Constants.h"
#import "Masonry.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "QuestionManager.h"
#import "UserManager.h"
#import "DGActivityIndicatorView.h"

@interface VTXVideoViewController () <TwilioConversationsClientDelegate, TWCConversationDelegate, TwilioAccessManagerDelegate, TWCParticipantDelegate, TWCLocalMediaDelegate, TWCVideoTrackDelegate, CameraViewDelegate>

@property (weak, nonatomic) UIAlertView *incomingAlert;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) CameraView *cameraView;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) TwilioConversationsClient *conversationsClient;
@property (nonatomic, strong) TwilioAccessManager *accessManager;
@property (nonatomic, strong) TWCLocalMedia *localMedia;
@property (nonatomic, strong) TWCCameraCapturer *camera;
@property (nonatomic, strong) TWCConversation *conversation;
@property (nonatomic, strong) TWCOutgoingInvite *outgoingInvite;
@property (nonatomic, strong) TWCVideoConstraints *videoContrains; // Need to use with TWCLocalVideoTrack
@property (nonatomic, assign) BOOL isConnected;

@end

@implementation VTXVideoViewController

- (instancetype)initWithToken:(NSString *)token {
    self = [super init];
    if (self) {
        self.token = token;
    }
    return self;
}

- (instancetype)initWithToken:(NSString *)token invitee:(NSString *)inviteeIdentity {
    self = [super init];
    if (self) {
        self.token = token;
        self.inviteeIdentity = inviteeIdentity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isConnected = NO;
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Video Chat Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"Video Chat" withParameters:nil timed:YES];
    [self listenForInvites];
    [self startConversation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Flurry endTimedEvent:@"Video Chat" withParameters:nil];
    [self showSpinner];
    if (self.incomingInvite) {
        /* This ViewController is being loaded to present an incoming Conversation request */
        [self hideSpinner];
        [self.incomingInvite acceptWithLocalMedia:self.localMedia
                                       completion:[self acceptHandler]];
    } else if ([self.inviteeIdentity length] > 0) {
        /* This ViewController is being loaded to present an outgoing Conversation request */
        [self sendConversationInvite];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    if (!self.cameraView) {
        self.cameraView = [[CameraView alloc] init];
        self.cameraView.delegate = self;
        [self.view addSubview:self.cameraView];
        [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (self.activityIndicator) {
        self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeThreeDots tintColor:[UIColor whiteColor]];
        self.activityIndicator.frame = CGRectMake(0, 0, 50.0, 30.0);
        self.activityIndicator.center = self.cameraView.center;
        [self.activityIndicator setHidden:YES];
        [self.cameraView addSubview:self.activityIndicator];
    }
}

- (void)showSpinner {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

- (void)hideSpinner {
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:YES];
}

- (void)listenForInvites {
    /* TWCLogLevelDisabled, TWCLogLevelError, TWCLogLevelWarning, TWCLogLevelInfo, TWCLogLevelDebug, TWCLogLevelVerbose  */
    [TwilioConversationsClient setLogLevel:TWCLogLevelError];
    
    if (!self.conversationsClient) {
        NSString *accessToken = self.token;
        self.accessManager = [TwilioAccessManager accessManagerWithToken:accessToken delegate:self];
        self.conversationsClient = [TwilioConversationsClient conversationsClientWithAccessManager:self.accessManager
                                                                                          delegate:self];
        [self.conversationsClient listen];
    }
}


- (void)startConversation {
    /* LocalMedia represents our local camera and microphone (media) configuration */
    self.localMedia = [[TWCLocalMedia alloc] initWithDelegate:self];
    
#if !TARGET_IPHONE_SIMULATOR
    /* Microphone is enabled by default, to enable Camera, we first create a Camera capturer */
    TWCCameraCapturer *cameraTrack = [[TWCCameraCapturer alloc] initWithSource:TWCVideoCaptureSourceFrontCamera];
    TWCLocalVideoTrack *localVideoTrack = [[TWCLocalVideoTrack alloc] initWithCapturer:cameraTrack constraints:[TWCVideoConstraints constraintsWithMaxSize:TWCVideoConstraintsSize1280x720 minSize:TWCVideoConstraintsSize960x540 maxFrameRate:0 minFrameRate:0]];
    [self.localMedia addTrack:localVideoTrack];
    self.camera = cameraTrack;
#else
    self.cameraView.localVideoContainer.hidden = YES;
    self.cameraView.pauseBtn.enabled = NO;
    self.cameraView.switchBtn.enabled = NO;
#endif
    
    /*
     We attach a view to display our local camera track immediately.
     You could also wait for localMedia:addedVideoTrack to attach a view or add a renderer.
     */
    if (self.camera) {
        [self.camera.videoTrack attach:self.cameraView.localVideoContainer];
        self.camera.videoTrack.delegate = self;
    }
    [self.camera startPreview];
    [self.cameraView.localVideoContainer addSubview:self.camera.previewView];
    self.camera.previewView.frame = self.cameraView.localVideoContainer.bounds;
    self.camera.previewView.contentMode = UIViewContentModeScaleAspectFill;
    
    /* For this demonstration, we always use Speaker audio output (vs. TWCAudioOutputReceiver) */
    [TwilioConversationsClient setAudioOutput:TWCAudioOutputSpeaker];
}

#pragma mark - CameraViewDelegate

- (void)handupVideo:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Handup Video"
                                                           label:@"Handup Video"
                                                           value:nil] build]];
    [Flurry logEvent:@"Handup Video"];
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
            if (self.isConnected) {
                [self endChat];
            }
        } @catch (NSException *exception) {
            NSLog(@"Fail to end consultation: %@", exception);
        } @finally {
            [self.conversation disconnect];
            [self.incomingInvite reject];
            [self.outgoingInvite cancel];
            self.localMedia = nil;
            self.conversation = nil;
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
    [alert addAction:ok];
    [alert addAction:give];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)endChat {
    if (self.consultation.consultationID) {
        [[QuestionManager defaultManager] endConsultation:self.consultation.consultationID withUser:[[UserManager defaultManager] currentUserID] andSuccess:^(BOOL finished) {
        } andError:^(NSError *error) {
            
        }];
    }
}

- (void)muteVideo:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Mute Video"
                                                           label:@"Mute Video"
                                                           value:nil] build]];
    [Flurry logEvent:@"Mute Video"];
    if (self.conversation) {
        self.conversation.localMedia.microphoneMuted = !self.conversation.localMedia.microphoneMuted;
    }
}

- (void)pauseVideo:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Pause Video"
                                                           label:@"Pause Video"
                                                           value:nil] build]];
    [Flurry logEvent:@"Pause Video"];
    
    if (self.conversation) {
        self.camera.videoTrack.enabled = !self.camera.videoTrack.enabled;
    }
}

- (void)switchCamera:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Switch Video Camera"
                                                           label:@"Switch Video Camera"
                                                           value:nil] build]];
    [Flurry logEvent:@"Switch Video Camera"];
    if (self.conversation) {
        [self.camera flipCamera];
    }
}

#pragma mark - TwilioConversationsClientDelegate
/* This method is invoked when an attempt to connect to Twilio and listen for Converation invites has succeeded */
- (void)conversationsClientDidStartListeningForInvites:(TwilioConversationsClient *)conversationsClient {
    NSLog(@"Now listening for Conversation invites...");
}

/* This method is invoked when an attempt to connect to Twilio and listen for Converation invites has failed */
- (void)conversationsClient:(TwilioConversationsClient *)conversationsClient didFailToStartListeningWithError:(NSError *)error {
    NSLog(@"Failed to listen for Conversation invites: %@", error);
    
}

/* This method is invoked when the SDK stops listening for Conversations invites */
- (void)conversationsClientDidStopListeningForInvites:(TwilioConversationsClient *)conversationsClient error:(NSError *)error {
    if (!error) {
        NSLog(@"Successfully stopped listening for Conversation invites");
        self.conversationsClient = nil;
    } else {
        NSLog(@"Stopped listening for Conversation invites (error): %ld", (long)error.code);
    }
    // Retry to listen for invites when failure happens
    [self listenForInvites];
}

/* This method is invoked when an incoming Conversation invite is received */
- (void)conversationsClient:(TwilioConversationsClient *)conversationsClient didReceiveInvite:(TWCIncomingInvite *)invite {
    NSLog(@"Conversations invite received: %@", invite);
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_press"
                                                           label:@"accept_video"
                                                           value:nil] build]];
    [Flurry logEvent:@"accept_video"];
    [Flurry logEvent:@"video_call" timed:YES];
    @try {
        self.incomingInvite = invite;
        self.isConnected = YES;
        if (self.incomingInvite) {
            /* This ViewController is being loaded to present an incoming Conversation request */
            [self hideSpinner];
            [self.incomingInvite acceptWithLocalMedia:self.localMedia
                                           completion:[self acceptHandler]];
        }
    } @catch (NSException *exception) {
        [self startConversation];
        [self.incomingInvite acceptWithLocalMedia:self.localMedia
                                       completion:[self acceptHandler]];
    } @finally {
        [self.cameraView.loadingLabel setHidden:YES];
    }
}

- (void)conversationsClient:(TwilioConversationsClient *)conversationsClient inviteDidCancel:(TWCIncomingInvite *)invite
{
    [self.incomingAlert dismissWithClickedButtonIndex:0 animated:YES];
    self.incomingInvite = nil;
}

#pragma mark -  TwilioAccessManagerDelegate

- (void)accessManagerTokenExpired:(TwilioAccessManager *)accessManager {
    NSLog(@"Token expired. Please update access manager with new token.");
}

- (void)accessManager:(TwilioAccessManager *)accessManager error:(NSError *)error {
    NSLog(@"AccessManager encountered an error : %ld", (long)error.code);
}


- (TWCInviteAcceptanceBlock)acceptHandler
{
    return ^(TWCConversation * _Nullable conversation, NSError * _Nullable error) {
        conversation.delegate = self;
        self.conversation = conversation;
    };
}

- (void)sendConversationInvite
{
    if (self.conversationsClient) {
        /* The createConversation method attempts to create and connect to a Conversation. The 'localStatusChanged' delegate method can be used to track the success or failure of connecting to the newly created Conversation.
         */
        self.outgoingInvite = [self.conversationsClient inviteToConversation:self.inviteeIdentity
                                                     localMedia:self.localMedia
                                                        handler:[self acceptHandler]];
    }
}

- (void)dismissConversation
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TWCConversationDelegate

- (void)conversation:(TWCConversation *)conversation didConnectParticipant:(TWCParticipant *)participant
{
    NSLog(@"Participant connected: %@", [participant identity]);
    self.isConnected = YES;
    participant.delegate = self;
}

- (void)conversation:(TWCConversation *)conversation didFailToConnectParticipant:(TWCParticipant *)participant error:(NSError *)error
{
    NSLog(@"Participant failed to connect: %@ with error: %@", [participant identity], error);
    
    [self.conversation disconnect];
    [self sendConversationInvite];
}

- (void)conversation:(TWCConversation *)conversation didDisconnectParticipant:(TWCParticipant*)participant
{
    NSLog(@"Participant disconnected: %@", [participant identity]);
    
    if ([self.conversation.participants count] <= 1) {
        [self.conversation disconnect];
    }
}

- (void)conversationEnded:(TWCConversation *)conversation
{
    [Flurry endTimedEvent:@"video_call" withParameters:nil];
    [self dismissConversation];
}

- (void)conversationEnded:(TWCConversation *)conversation error:(NSError *)error
{
    [Flurry endTimedEvent:@"video_call" withParameters:nil];
    [self dismissConversation];
}

#pragma mark - TWCLocalMediaDelegate

- (void)localMedia:(TWCLocalMedia *)media didAddVideoTrack:(TWCVideoTrack *)videoTrack
{
    NSLog(@"Local video track added: %@", videoTrack);
}

- (void)localMedia:(TWCLocalMedia *)media didRemoveVideoTrack:(TWCVideoTrack *)videoTrack
{
    NSLog(@"Local video track removed: %@", videoTrack);
    
    /* You do not need to call [videoTrack detach:] here, your view will be detached once this call returns. */
    TWCCameraCapturer *cameraTrack = [[TWCCameraCapturer alloc] initWithSource:TWCVideoCaptureSourceFrontCamera];
    TWCLocalVideoTrack *localVideoTrack = [[TWCLocalVideoTrack alloc] initWithCapturer:cameraTrack constraints:[TWCVideoConstraints constraintsWithMaxSize:TWCVideoConstraintsSize1280x720 minSize:TWCVideoConstraintsSize960x540 maxFrameRate:0 minFrameRate:0]];
    [self.localMedia addTrack:localVideoTrack];
    self.camera = cameraTrack;
   [self.camera.videoTrack attach:self.cameraView.localVideoContainer]; 
//    [self startConversation];
//    self.camera = nil;
}

#pragma mark - TWCParticipantDelegate

- (void)participant:(TWCParticipant *)participant addedVideoTrack:(TWCVideoTrack *)videoTrack
{
    NSLog(@"Video added for participant: %@", [participant identity]);
    
    [videoTrack attach:self.cameraView.remoteVideoContainer];
    videoTrack.delegate = self;
}

- (void)participant:(TWCParticipant *)participant removedVideoTrack:(TWCVideoTrack *)videoTrack
{
    NSLog(@"Video removed for participant: %@", [participant identity]);
    
    /* You do not need to call [videoTrack detach:] here, your view will be detached once this call returns. */
}

- (void)participant:(TWCParticipant *)participant addedAudioTrack:(TWCAudioTrack *)audioTrack
{
    NSLog(@"Audio added for participant: %@", participant.identity);
}

- (void)participant:(TWCParticipant *)participant removedAudioTrack:(TWCAudioTrack *)audioTrack
{
    NSLog(@"Audio removed for participant: %@", participant.identity);
}

- (void)participant:(TWCParticipant *)participant enabledTrack:(TWCMediaTrack *)track
{
    NSLog(@"Enabled track: %@", track);
}

- (void)participant:(TWCParticipant *)participant disabledTrack:(TWCMediaTrack *)track
{
    NSLog(@"Disabled track: %@", track);
}

#pragma mark - TWCVideoTrackDelegate

- (void)videoTrack:(TWCVideoTrack *)track dimensionsDidChange:(CMVideoDimensions)dimensions
{
    NSLog(@"Dimensions changed to: %d x %d", dimensions.width, dimensions.height);
    
    [self.view setNeedsUpdateConstraints];
}

@end
