//
//  CameraView.m
//  VetX
//
//  Created by YulianMobile on 3/29/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "CameraView.h"
#import "Constants.h"
#import "Masonry.h"

@interface CameraView ()


@end

@implementation CameraView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor blackColor];
    if (!self.remoteVideoContainer) {
        self.remoteVideoContainer = [[UIView alloc] init];
        [self.remoteVideoContainer setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:self.remoteVideoContainer];
        [self.remoteVideoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    if (!self.localVideoContainer) {
        self.localVideoContainer = [[UIView alloc] init];
        [self.localVideoContainer setBackgroundColor:[UIColor whiteColor]];
        [self.localVideoContainer setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.localVideoContainer];
        [self.localVideoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@120);
            make.height.equalTo(@160);
            make.top.equalTo(self).offset(32);
            make.leading.equalTo(@20);
        }];
    }
    
    if (!self.controlsContainer) {
        self.controlsContainer = [[UIView alloc] init];
        [self.controlsContainer setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.controlsContainer];
        [self.controlsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-25);
            make.height.equalTo(@144);
            make.left.equalTo(self.mas_left).offset(94.0f);
            make.right.equalTo(self.mas_right).offset(-94.0f);
        }];
    }
    
    if (!self.loadingLabel) {
        self.loadingLabel = [[UILabel alloc] init];
        [self.loadingLabel setText:@"Hold on, we are connecting..."];
        [self.loadingLabel setFont:VETX_FONT_LIGHT_14];
        [self.loadingLabel setTextColor:[UIColor whiteColor]];
        [self.remoteVideoContainer addSubview:self.loadingLabel];
        [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.remoteVideoContainer);
        }];
    }
    
    if (!self.handupBtn) {
        self.handupBtn = [[UIButton alloc] init];
        [self.handupBtn setImage:[UIImage imageNamed:@"End Call Button"] forState:UIControlStateNormal];
        [self.handupBtn addTarget:self action:@selector(clickHandup) forControlEvents:UIControlEventTouchUpInside];
        [self.controlsContainer addSubview:self.handupBtn];
        [self.handupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@56);
            make.center.equalTo(self.controlsContainer);
        }];
    }
    
    if (!self.pauseBtn) {
        self.pauseBtn = [[UIButton alloc] init];
        [self.pauseBtn setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        [self.pauseBtn setImage:[UIImage imageNamed:@"Resume"] forState:UIControlStateSelected];
        [self.pauseBtn addTarget:self action:@selector(clickPauseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.controlsContainer addSubview:self.pauseBtn];
        [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(self.handupBtn);
            make.centerY.equalTo(self.controlsContainer);
            make.right.equalTo(self.handupBtn.mas_left).offset(-30);
        }];
    }
    
    if (!self.muteBtn) {
        self.muteBtn = [[UIButton alloc] init];
        [self.muteBtn setImage:[UIImage imageNamed:@"Speaker"] forState:UIControlStateNormal];
        [self.muteBtn setImage:[UIImage imageNamed:@"Mute"] forState:UIControlStateSelected];
        [self.muteBtn addTarget:self action:@selector(clickMuteBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.controlsContainer addSubview:self.muteBtn];
        [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(self.handupBtn);
            make.centerY.equalTo(self.controlsContainer);
            make.left.equalTo(self.handupBtn.mas_right).offset(30);
        }];
    }
    
    if (!self.switchBtn) {
        self.switchBtn = [[UIButton alloc] init];
        [self.switchBtn setImage:[UIImage imageNamed:@"Switch Camera Button"] forState:UIControlStateNormal];
        [self.switchBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.switchBtn addTarget:self action:@selector(clickSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.switchBtn];
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@30);
            make.top.equalTo(self.mas_top).offset(32);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
    }
}


- (void)clickHandup {
    if ([self.delegate respondsToSelector:@selector(handupVideo:)]) {
        [self.delegate performSelector:@selector(handupVideo:) withObject:self.handupBtn];
    }
}

- (void)clickPauseBtn {
    self.pauseBtn.selected = !self.pauseBtn.selected;
    if ([self.delegate respondsToSelector:@selector(pauseVideo:)]) {
        [self.delegate performSelector:@selector(pauseVideo:) withObject:self.pauseBtn];
    }
}

- (void)clickMuteBtn {
    self.muteBtn.selected = !self.muteBtn.selected;
    if ([self.delegate respondsToSelector:@selector(muteVideo:)]) {
        [self.delegate performSelector:@selector(muteVideo:) withObject:self.muteBtn];
    }
}

- (void)clickSwitchBtn {
    if ([self.delegate respondsToSelector:@selector(switchCamera:)]) {
        [self.delegate performSelector:@selector(switchCamera:) withObject:self.switchBtn];
    }
}

@end
