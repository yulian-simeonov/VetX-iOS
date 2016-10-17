//
//  VTXConfirmationView.h
//  VetX
//
//  Created by YulianMobile on 4/19/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    General,
    Chat,
    Video,
} ConfirmationType;

@protocol VTXConfirmationDelegate <NSObject>

- (void)didClickOK;

@end

@interface VTXConfirmationView : UIView

@property (nonatomic, assign) id<VTXConfirmationDelegate> delegate;

- (void)setConfirmationType:(ConfirmationType)type;

@end
