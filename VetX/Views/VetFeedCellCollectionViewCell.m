//
//  VetFeedCellCollectionViewCell.m
//  VetX
//
//  Created by YulianMobile on 2/3/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VetFeedCellCollectionViewCell.h"
#import "Masonry.h"


@interface VetFeedCellCollectionViewCell ()


@end

@implementation VetFeedCellCollectionViewCell

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    if (!self.vetProfileImage) {
        self.vetProfileImage = [[UIImageView alloc] init];
        [self.vetProfileImage setImage:[UIImage imageNamed:@"DefaultPlaceHolder"]];
        [self.vetProfileImage.layer setCornerRadius:20.0];
        [self.vetProfileImage setClipsToBounds:YES];
        [self.contentView addSubview:self.vetProfileImage];
        [self.vetProfileImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}

@end
