//
//  AddPetTableViewCell.m
//  VetX
//
//  Created by YulianMobile on 5/13/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "AddPetTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface AddPetTableViewCell ()

@property (nonatomic, strong) UIImageView *addPet;

@end

@implementation AddPetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView setBackgroundColor:FEED_BACKGROUND_COLOR];

    if (!self.addPet) {
        self.addPet = [[UIImageView alloc] init];
        [self.addPet setImage:[UIImage imageNamed:@"Add_More_Pet"]];
        [self addSubview:self.addPet];
        [self.addPet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@215);
            make.height.equalTo(@135);
        }];
    }
    [self setNeedsLayout];
}
@end
