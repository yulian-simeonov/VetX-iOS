//
//  CameraView.h
//  VetX
//
//  Created by YulianMobile on 3/29/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraViewDelegate <NSObject>

- (void)handupVideo:(id)sender;
- (void)muteVideo:(id)sender;
- (void)pauseVideo:(id)sender;
- (void)switchCamera:(id)sender;

@end

@interface CameraView : UIView

@property (nonatomic, assign) id<CameraViewDelegate> delegate;

@property (nonatomic, strong) UIView *remoteVideoContainer;
@property (nonatomic, strong) UIView *localVideoContainer;
@property (nonatomic, strong) UIView *controlsContainer;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIButton *handupBtn;
@property (nonatomic, strong) UIButton *muteBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *switchBtn;

@end
