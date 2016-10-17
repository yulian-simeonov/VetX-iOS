//
//  SuggestionRequestModel.h
//  VetX
//
//  Created by Liam Dyer on 2/16/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SuggestionRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *text;

@end
