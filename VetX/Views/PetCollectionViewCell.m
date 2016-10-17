//
//  PetCollectionViewCell.m
//  VetX
//
//  Created by YulianMobile on 1/4/16.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "PetCollectionViewCell.h"
#import "Masonry.h"

@interface PetCollectionViewCell ()

@end

@implementation PetCollectionViewCell


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
      [self setupCell];
    }
    return self;
}

- (void)setupCell {
    if (!self.petImageView) {
        self.petImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self.petImageView.layer setCornerRadius:CGRectGetWidth(self.petImageView.frame)/2.0];
        [self.petImageView setClipsToBounds:YES];
        [self addSubview:self.petImageView];
        [self.petImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}
@end
