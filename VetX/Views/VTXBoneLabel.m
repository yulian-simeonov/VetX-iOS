//
//  VTXBoneLabel.m
//  VetX
//
//  Created by YulianMobile on 3/1/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXBoneLabel.h"
#import "Masonry.h"
#import "Constants.h"

@interface VTXBoneLabel ()

@property (nonatomic, strong) UIImageView *boneView;
@property (nonatomic, strong) UILabel *itemLabel;

@end

@implementation VTXBoneLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    if (!self.boneView) {
        self.boneView = [[UIImageView alloc] init];
        [self.boneView setTintColor:GREY_COLOR];
        [self.boneView setImage:[[UIImage imageNamed:@"DogBone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self addSubview:self.boneView];
        [self.boneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@20);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(30);
        }];
    }
    
    if (!self.itemLabel) {
        self.itemLabel = [[UILabel alloc] init];
        [self.itemLabel setTextColor:GREY_COLOR];
        [self.itemLabel setFont:VETX_FONT_BOLD_15];
        [self.itemLabel setNumberOfLines:0];
        [self.itemLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.boneView.mas_right).offset(10);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-10.0f);
        }];
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.itemLabel).offset(5);
    }];

}

- (void)setItemText:(NSString *)item {
    [self.itemLabel setText:item];
}


@end
