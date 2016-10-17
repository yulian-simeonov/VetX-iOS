//
//  VTXVideoAndChatConfirmationView.h
//  VetX
//
//  Created by YulianMobile on 5/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ConsultationChat,
    ConsultationVideo,
} OneOnOneType;

@protocol VTXVideoAndChatConfirmationViewDelegate <NSObject>

- (void)didClickConfirm;

@end

@interface VTXVideoAndChatConfirmationView : UIView

@property (nonatomic, assign) id<VTXVideoAndChatConfirmationViewDelegate> delegate;

- (void)setOneOnOneConfirmationType:(OneOnOneType)type;

@end
