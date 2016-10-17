//
//  VTXMedicalRecordsViewController.m
//  VetX
//
//  Created by YulianMobile on 3/24/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXMedicalRecordsViewController.h"
#import "UserManager.h"
#import "SignUpLoginViewController.h"
#import "Constants.h"
#import "VTXMedicalRecordTableViewCell.h"
#import "Masonry.h"
#import <Google/Analytics.h>
#import <Photos/Photos.h>
#import "Flurry.h"
#import "VTXEmptyView.h"
#import "VTXMedicalRecordItemView.h"
#import "SDImageCache.h"
#import "MWPhotoBrowser.h"
#import "Record.h"
#import "UIImage+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AddPetTableViewCell.h"
#import "VTXAddPetView.h"
#import "UIImage+ImageOperations.h"
#import "SCLAlertView.h"

@interface VTXMedicalRecordsViewController ()<UITableViewDelegate, UITableViewDataSource, VTXEmptyViewDelegate, VTXMedicalRecordCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MWPhotoBrowserDelegate, VTXAddPetViewDelegate>

@property (nonatomic, strong) SignUpLoginViewController *signupVC;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VTXEmptyView *emptyView;
@property (nonatomic, strong) VTXAddPetView *addPetView;

@property (nonatomic, assign) BOOL addPetImage;
@property (nonatomic, strong) UIImage *petImageToUpload;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *photoURLs;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSNumber *recordType;
@property (nonatomic, strong) RLMArray <Pet *><Pet> *petArray;

@end

@implementation VTXMedicalRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"My Records"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupView];
    if ([[UserManager defaultManager] currentUser]) {
        [self getMedicalRecord];
    } else {
        [self presendtSignupLogin];
        [self addEmptyPage];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Medical Record Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if ([[UserManager defaultManager] currentUser]) {
        [self getMedicalRecord];
    }
    [Flurry logEvent:@"Medical Record" withParameters:nil timed:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [Flurry endTimedEvent:@"Medical Record" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMedicalRecord {
    self.petArray = [[[UserManager defaultManager] currentUser] pets];
    if (self.petArray.count == 0) {
        [self addEmptyPage];
    } else {
        [self.emptyView removeFromSuperview];
    }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@", [UserManager defaultManager].currentUserID];
    __weak typeof(self) weakSelf = self;
    [[User objectsWithPredicate:predicate] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange *changes,  NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (results.count > 0) {
                User *user = results[0];
                strongSelf.petArray = user.pets;
                if (strongSelf.petArray.count == 0) {
                    [strongSelf addEmptyPage];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.emptyView removeFromSuperview];
                        [strongSelf.tableView reloadData];
                    });
                }
            }
        }
    }];
}

- (void)setupView {
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setBackgroundColor:FEED_BACKGROUND_COLOR];
        [self.tableView registerClass:[VTXMedicalRecordTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerClass:[AddPetTableViewCell class] forCellReuseIdentifier:@"AddPetCell"];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)addEmptyPage {
    if (!self.emptyView) {
        self.emptyView = [[VTXEmptyView alloc] init];
        [self.emptyView setEmptyScreenType:EmptyRecord];
        self.emptyView.delegate = self;
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark - Empty Page Delegate
- (void)didClickBtn {
    // Add pet here
    [self showAddPetView:nil];
}

#pragma mark - Signup & Login

- (void)presendtSignupLogin {
    
    self.signupVC = [[SignUpLoginViewController alloc] init];
    self.signupVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.signupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [self presentViewController:self.signupVC animated:YES completion:^{
        
    }];
}

#pragma mark - TableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.petArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.petArray.count) {
        VTXMedicalRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[VTXMedicalRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell bindPetData:[self.petArray objectAtIndex:indexPath.row]];
        return cell;
    } else {
        AddPetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPetCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[AddPetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.petArray.count) {
        return 410.0f;
    } else {
        return 145.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.petArray.count) {
        NSLog(@"add pet");
        [self showAddPetView:nil];
    }
}

- (void)showAddPetView:(Pet *)pet {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Add Pet In Medical Record"
                                                           label:@"Add Pet In Medical Record"
                                                           value:nil] build]];
    [Flurry logEvent:@"Add Pet In Medical Record"];
    if (!self.addPetView) {
        self.addPetView = [[VTXAddPetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    self.addPetView.type = [[NSMutableArray alloc] initWithArray:@[@"Dog", @"Cat"]];
    self.addPetView.request = [[AddPetRequestModel alloc] init];
    self.addPetView.delegate = self;
    [[UserManager defaultManager] getPetTypeBreedComplete:^(BOOL finished, NSDictionary *data) {
        self.addPetView.typeBreed = data;
        self.addPetView.breed= [data objectForKey:@"Cat"];
    }];
    [self.addPetView setPetInfo:pet];
    [self.view addSubview:self.addPetView];
    [self.addPetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.addPetImage = YES;
}

- (void)didAddPet:(AddPetRequestModel *)request {
    if (!request.petName || [request.petName isEqualToString:@""]) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet name cannot be empty"];
        return;
    } else if (!request.petSex) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet sex cannot be empty"];
        return;
    } else if (!request.petType || !request.petBreed) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet's type and breed cannot be empty"];
        return;
    } else  if (!request.petBirthday) {
        [self showErrorAlertWithTitle:@"Add Pet Error" message:@"Pet's birthday cannot be empty"];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showSpinner];
        [self.addPetView.submitBtn setEnabled:NO];
    });
    
    if (request.petID) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Did Update Pet Information In Medical Record"
                                                               label:@"Did Update Pet Information In Medical Record"
                                                               value:nil] build]];
        [Flurry logEvent:@"Did Update Pet Information In Medical Record"];
        [[UserManager defaultManager] updatePet:request.petID info:request andProfile:UIImageJPEGRepresentation(self.petImageToUpload, 0.75) andSuccess:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UserManager defaultManager] getLatestCurrentUserInfo];
                [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                [self.addPetView.submitBtn setEnabled:YES];
                [self.tableView reloadData];
                [self.addPetView removeFromSuperview];
            });
        } andError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            [self.addPetView.submitBtn setEnabled:YES];
        }];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                              action:@"Did Add Pet Information In Medical Record"
                                                               label:@"Did Add Pet Information In Medical Record"
                                                               value:nil] build]];
        [Flurry logEvent:@"Did Add Pet Information In Medical Record"];
        [[UserManager defaultManager] addPet:request andProfile:UIImageJPEGRepresentation(self.petImageToUpload, 0.75) andSuccess:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UserManager defaultManager] getLatestCurrentUserInfo];
                [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                [self.addPetView.submitBtn setEnabled:YES];
                [self.tableView reloadData];
                [self.addPetView removeFromSuperview];
            });
        } andError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            [self.addPetView.submitBtn setEnabled:YES];
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UserManager defaultManager] getLatestCurrentUserInfo];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [self.tableView reloadData];
        [self.addPetView removeFromSuperview];
    });
}


- (void)closeAddPet {
    [self.addPetView removeFromSuperview];
}

- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)msg {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self title:title subTitle:msg closeButtonTitle:@"OK" duration:0.0];
}

#pragma mark - Medical Record Item Delegate

- (void)addRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath {
    // According to the indexpath, get the right pet info.
    // According to the item type, get to know the record type
    self.recordType = item;
    self.selectedIndexPath = indexPath;
    self.addPetImage = NO;
    [self openImagePicker];
}

- (void)shareRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Share Records"
                                                           label:@"Share Records"
                                                           value:nil] build]];
    [Flurry logEvent:@"Share Records"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showSpinner];
    });
    self.recordType = item;
    self.selectedIndexPath = indexPath;
    self.photoURLs = [NSMutableArray array];
    if ([item integerValue] == 0) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] certificateOfHealth]) {
            [self.photoURLs addObject:[NSURL URLWithString:record.record]];
        }
    } else if ([item integerValue] == 1) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] vaccinationRecord]) {
            [self.photoURLs addObject:[NSURL URLWithString:record.record]];
        }
    } else if ([item integerValue] == 2) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] laboratoryResults]) {
            [self.photoURLs addObject:[NSURL URLWithString:record.record]];
        }
    } else if ([item integerValue] == 3) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] patientChart]) {
            [self.photoURLs addObject:[NSURL URLWithString:record.record]];
        }
    } else if ([item integerValue] == 4) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] invoiceRecord]) {
            [self.photoURLs addObject:[NSURL URLWithString:record.record]];
        }
    } else {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] other]) {
            [self.photoURLs addObject:[NSURL URLWithString:record.record]];
        }
    }
    if ([self.photoURLs count] >= 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:self.photoURLs[0]];
            UIImage *record = [UIImage imageWithData:imageData];
            UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[record] applicationActivities:nil];
            activity.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                [self presentViewController:activity animated:YES completion:nil];
            });
        });
    }
}

- (void)editRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Delete Records"
                                                           label:@"Delete Records"
                                                           value:nil] build]];
    [Flurry logEvent:@"Delete Records"];
    self.selectedIndexPath = indexPath;
    self.recordType = item;
    [self showAlert];
}

- (void)viewRecord:(NSNumber *)item indexPath:(NSIndexPath *)indexPath {
    self.recordType = item;
    self.selectedIndexPath = indexPath;
    self.photos = [NSMutableArray array];
    if ([item integerValue] == 0) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] certificateOfHealth]) {
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:record.record]]];
        }
    } else if ([item integerValue] == 1) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] vaccinationRecord]) {
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:record.record]]];
        }
    } else if ([item integerValue] == 2) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] laboratoryResults]) {
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:record.record]]];
        }
    } else if ([item integerValue] == 3) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] patientChart]) {
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:record.record]]];
        }
    } else if ([item integerValue] == 4) {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] invoiceRecord]) {
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:record.record]]];
        }
    } else {
        for (Record *record in [[self.petArray objectAtIndex:indexPath.row] other]) {
            [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:record.record]]];
        }
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayNavArrows = YES;
    browser.zoomPhotosToFill = YES;
    [browser setCurrentPhotoIndex:1];
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Delete Record?"
                                message:@"Are you sure you want to delete your pet's Medical Record?"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *petID = [self.petArray objectAtIndex:self.selectedIndexPath.row].petID;
        NSString *deleteType = [self getRecordType:self.recordType];
        [self showSpinner];
        [[UserManager defaultManager] deleteMedicalRecord:petID type:deleteType success:^(BOOL finished) {
            [[UserManager defaultManager] getLatestCurrentUserInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            });
        } andError:^(NSError *error) {
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)openImagePicker {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"Add Pet Medical Record"
                                                           label:@"Add Pet Medical Record"
                                                           value:nil] build]];
    [Flurry logEvent:@"Add Pet Medical Record"];
    UIAlertController *addPetImageOptions;
    if (self.addPetImage) {
        addPetImageOptions = [UIAlertController alertControllerWithTitle:@"Upload Pet Profile Image" message:@"Add a profile image for your lovely pet!" preferredStyle:UIAlertControllerStyleActionSheet];
    } else {
        addPetImageOptions = [UIAlertController alertControllerWithTitle:@"Upload Your Medical Record" message:@"Add medical record for your lovely pet!" preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *camera=[[UIImagePickerController alloc]init];
            [camera setSourceType:UIImagePickerControllerSourceTypeCamera];
            [camera setDelegate:self];
            [self presentViewController:camera animated:YES completion:nil];
        }
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *photoLibrary=[[UIImagePickerController alloc]init];
            [photoLibrary setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [photoLibrary setDelegate:self];
            [self presentViewController:photoLibrary animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancenl = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [addPetImageOptions addAction:camera];
    [addPetImageOptions addAction:library];
    [addPetImageOptions addAction:cancenl];
    
    
    [self presentViewController:addPetImageOptions animated:YES completion:^{
    }];
}

- (void)showSpinner {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
}

#pragma mark - MWPhoto Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.addPetImage) {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        CGFloat w=400.0;
        CGFloat h=400.0/chosenImage.size.width * chosenImage.size.height;
        UIImage *croppedImage = [chosenImage imagescaledToSize:CGSizeMake(w, h)];
        self.petImageToUpload = croppedImage;
        [self.addPetView.petImageProfile setImage:croppedImage forState:UIControlStateNormal];
        [self.view setNeedsDisplay];
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];

    NSData *data = UIImageJPEGRepresentation(chosenImage, 0.7);
    NSString *petID = [self.petArray objectAtIndex:self.selectedIndexPath.row].petID;
    NSString *type = [self getRecordType:self.recordType];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showSpinner];
    });
    [[UserManager defaultManager] addMedicalRecord:petID image:data type:type success:^(BOOL finished) {
        [[UserManager defaultManager] getLatestCurrentUserInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        });
    } andError:^(NSError *error) {

    }];
    
    [self.view setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:^{}];

}

- (NSString *)getRecordType:(NSNumber *)type {
    switch ([type integerValue]) {
        case 0:
            return @"certificateOfHealth";
            break;
        case 1:
            return @"vaccinationRecord";
            break;
        case 2:
            return @"laboratoryResults";
            break;
        case 3:
            return @"patientChart";
            break;
        case 4:
            return @"invoiceRecord";
            break;
        default:
            return @"other";
            break;
    }
}

@end
