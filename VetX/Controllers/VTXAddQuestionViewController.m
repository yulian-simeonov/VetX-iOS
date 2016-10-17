//
//  AddQuestionViewController.m
//  VetX
//
//  Created by Liam Dyer on 2/17/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXAddQuestionViewController.h"
#import "VTXAddQuestionView.h"
#import "Masonry.h"
#import <Braintree/BraintreeUI.h>
#import <RBQFetchedResultsController/RBQFRC.h>
#import <AVFoundation/AVFoundation.h>
#import "VTXChatViewController.h"
#import "UserManager.h"
#import "VTXChatManager.h"
#import "VXPaymentManager.h"
#import "PetCollectionViewCell.h"
#import "VTXAddPetView.h"
#import "Constants.h"
#import "UIImage+ImageOperations.h"
#import "AddPetRequestModel.h"
#import "QuestionManager.h"
#import "UIImageView+AFNetworking.h"
#import "VTXVideoViewController.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import "VTXConfirmationView.h"
#import "VTXVideoAndChatConfirmationView.h"
#import "SCLAlertView.h"
#import "VTXPromoCodeController.h"

@interface VTXAddQuestionViewController () <VTXAddQuestionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VTXConfirmationDelegate, VTXVideoAndChatConfirmationViewDelegate>

@property (nonatomic, assign) BOOL addPetImage;
@property (nonatomic, strong) UIImage *petImageToUpload;
@property (nonatomic, strong) UIImage *questionImageToUpload;
@property (nonatomic, strong) AddPetRequestModel *addPetRequestModel;
@property (nonatomic, strong) RBQFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) VTXAddQuestionView *addQuestionView;

@property (nonatomic, strong) VTXConfirmationView *confirmView;
@property (nonatomic, strong) VTXVideoAndChatConfirmationView *oneOnOneConfirmation;

@property (nonatomic, strong) RLMArray <Pet *><Pet> *petArray;
@property (nonatomic, strong) Pet *selectedPet;
@property (nonatomic, strong) NSNumber *isVideo;

@end

@implementation VTXAddQuestionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(postQuestion)];
    [right setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:right];
    self.hidesBottomBarWhenPushed = true;
    
    self.addPetImage = NO;
    [self getPetInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationItem setTitle:@"Ask Question"];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Post Question Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Flurry logEvent:@"add_question" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationItem setTitle:@""];
    
    self.fetchedResultsController = nil;
    [Flurry endTimedEvent:@"add_question" withParameters:nil];
}

- (void)setupView {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (!self.addQuestionView) {
        self.addQuestionView = [[VTXAddQuestionView alloc] init];
        self.addQuestionView.petArray = self.petArray;
        [self.addQuestionView.questionTitleField becomeFirstResponder];
        self.addQuestionView.delegate = self;
        [self.view addSubview:self.addQuestionView];
        [self.addQuestionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)initQuestionTitle:(NSString *)title {
    [self.addQuestionView.questionTitleField setText:title];
}

- (void)startOneOnOne:(NSNumber *)isVideo {
    self.isVideo = isVideo;
    VTXPromoCodeController *vtxc = [[VTXPromoCodeController alloc] init];
    vtxc.questionTitleString = self.addQuestionView.questionTitleField.text;
    vtxc.isVideo = self.isVideo;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vtxc animated:YES];

}

- (void)postQuestion {
    [self.addQuestionView.questionTitleField resignFirstResponder];
    [self.addQuestionView.questionTextView resignFirstResponder];
    if (self.addQuestionView.questionTitleField.text.length == 0) {
        // Pop up an alert to add question title
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:300.0f];
        alert.customViewColor = ORANGE_THEME_COLOR;
        [alert showQuestion:self title:@"New Question?" subTitle:@"Please add your question and its details so that our vets can provide more accurate answers!" closeButtonTitle:@"OK" duration:0.0f]; // Info
        return;
    }

    [self.addQuestionView postQuestionClicked];
}

- (void)postGeneral {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Post General Question"
                                                           label:@"Post General Question"
                                                           value:nil] build]];
    [Flurry logEvent:@"Post General Question"];
    NSString *question = [self.addQuestionView.questionTitleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *details = [self.addQuestionView.questionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *category = [[self.addQuestionView.categoryField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"Topic: " withString:@""];

    if ([question isEqualToString:@""]) {
        NSLog(@"Must have a question title");
    }
    
    if ([details isEqualToString:@"Go into more detail here...(Optional)"]) {
        details = @"";
    }
    
    PostQuestionRequestModel *request = [[PostQuestionRequestModel alloc] init];
    request.questionTitle = question;
    request.questionDetails = details;
    request.questionCategory = category;
    if (self.selectedPet) {
        request.questionPetID = self.selectedPet.petID;
    }

    NSData *imageData = UIImagePNGRepresentation(self.questionImageToUpload);
    [[QuestionManager defaultManager] postQuestion:request andProfile:imageData];
    
    // Show confirmation page first then pop viewcontroller
    [self addConfirmationView];
}

- (void)didClickOK {
    [self goBack];
}

- (void)goBack {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectedPet:(Pet *)pet {
    self.selectedPet = pet;
}

- (void)addConfirmationView {
    if (!self.confirmView) {
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
        [self.view addSubview:backgroundView];
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        self.confirmView = [[VTXConfirmationView alloc] init];
        self.confirmView.delegate = self;
        [backgroundView addSubview:self.confirmView];
        [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@280);
            make.height.equalTo(@400);
        }];
    }
}



- (void)showErrorAlert:(NSString *)errorDetails {
    
}

- (void)addQestionImage {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Add Question Image"
                                                           label:@"Add Question Image"
                                                           value:nil] build]];
    [Flurry logEvent:@"Add Question Image"];
    UIAlertController *addImageOptions = [UIAlertController alertControllerWithTitle:@"Upload Image" message:@"Add an image for your question" preferredStyle:UIAlertControllerStyleActionSheet];
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
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [addImageOptions addAction:camera];
    [addImageOptions addAction:library];
    [addImageOptions addAction:cancenl];
    [self presentViewController:addImageOptions animated:YES completion:^{
        self.addPetImage = NO;
    }];
}

#pragma mark - Get Pet Info From Cache
- (void)getPetInfo {
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@", [UserManager defaultManager].currentUserID];
    RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:@"User"
                                                                        inRealm:realm
                                                                      predicate:predicate];
    self.fetchedResultsController = [[RBQFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:@"pet"];    
    [self.fetchedResultsController performFetch];
    User *user = (User *)[self.fetchedResultsController.fetchedObjects objectAtIndex:0];
    self.petArray = user.pets;
    self.addQuestionView.petArray = self.petArray;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    CGFloat w=400.0;
    CGFloat h=400.0/chosenImage.size.width * chosenImage.size.height;
    UIImage *croppedImage = [chosenImage imagescaledToSize:CGSizeMake(w, h)];
    if (self.addPetImage) {
        self.petImageToUpload = croppedImage;
    } else {
        [self.addQuestionView.addImageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.addQuestionView.addImageBtn setImage:croppedImage forState:UIControlStateNormal];
        [self.addQuestionView updateQuestionImageView];
        self.questionImageToUpload = croppedImage;
    }
    [self.view setNeedsDisplay];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

@end
