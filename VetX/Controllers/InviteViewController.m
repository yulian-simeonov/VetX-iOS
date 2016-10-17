//
//  InviteViewController.m
//  VetX
//
//  Created by YulianMobile on 1/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "InviteViewController.h"
#import "Constants.h"
#import "InviteView.h"
#import "Masonry.h"
#import "ReferralCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface InviteViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *referrals;

@property (nonatomic, strong) InviteView *inviteView;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"INVITE"];

    [self setupViews];
    [self getPromoCode];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    if (!self.inviteView) {
        self.inviteView = [[InviteView alloc] init];
        self.inviteView.collectionView.delegate = self;
        self.inviteView.collectionView.dataSource = self;
        [self.view addSubview:self.inviteView];
        [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)getPromoCode {
    
//    if ([[PFUser currentUser] objectForKey:@"promo"] == nil) {
//        return;
//    }
//    NSString *capPromo = [[[PFUser currentUser] objectForKey:@"promo"] uppercaseString];
//    [self.inviteView setReferralCode:capPromo];
//    [PFCloud callFunctionInBackground:@"GetReferrals"
//                       withParameters:@{@"refId":capPromo}
//                                block:^(NSDictionary *result, NSError *error) {
//                                    if (!error) {
//                                        if ([[result objectForKey:@"status"] isEqualToString:@"success"]) {
//                                            self.referrals = [result objectForKey:@"result"];
//                                            NSLog(@"received result: %@", self.referrals);
//                                            [self.inviteView.collectionView reloadData];
//                                        }
//                                    }
//                                }];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.referrals.count;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ReferralCell";
    
    ReferralCollectionViewCell *cell = (ReferralCollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    [cell.imgView.layer setCornerRadius:cell.imgView.frame.size.height/2];
    [cell.imgView setClipsToBounds:YES];
    [cell.imgView.layer setBorderColor:APP_THEME_COLOR_LIGHT.CGColor];
    [cell.imgView.layer setBorderWidth:2];
    
    NSString *imgUrl=@"";
//    PFFile *file=[self.referrals[indexPath.row] objectForKey:@"avatar"];
//    if (file) {
//        [file getDataInBackgroundWithBlock:^(NSData *  data, NSError * error) {
//            [cell.imgView setImage:[UIImage imageWithData:data]];
//            
//        }];
//    }else{
//        [cell.imgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
//    }
    
    return cell;
}


- (IBAction)shareBtnClicked:(id)sender {
//    NSString *eventTitle = [NSString stringWithFormat:@"Consult a veterinarian 24/7 through the VetX app! Get instant medical, behavioral, or general advice for your furry friends! Use my code \"%@\" to start your 1 month free trial! https://appsto.re/us/rd7q-.i !", [[PFUser currentUser] objectForKey:@"promo"]];
//    NSArray *activityItems = @[eventTitle];
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//    [self presentViewController:activityVC animated:TRUE completion:nil];
}

@end
