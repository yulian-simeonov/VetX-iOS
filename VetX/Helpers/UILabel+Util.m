//
//  UILabel+Util.m
//  VetX
//
//  Created by Liam Dyer on 2/24/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "UILabel+Util.h"

@implementation UILabel (Util)

- (CGFloat)textWidth {
    return [self.text boundingRectWithSize:self.frame.size
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: self.font}
                                   context:nil].size.width;
}

@end
