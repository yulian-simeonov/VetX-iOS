//
//  VTXEmptyView.h
//  VetX
//
//  Created by YulianMobile on 4/24/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EmptyQuestion,
    EmptyRecord,
    EmptyProfile,
    EmptyAnswers
} EmptyType;

@protocol VTXEmptyViewDelegate <NSObject>

- (void)didClickBtn;

@end

@interface VTXEmptyView : UIView

@property (nonatomic, assign) id<VTXEmptyViewDelegate> delegate;

- (void)setEmptyScreenType:(EmptyType)type;

@end
