//
//  Record.h
//  VetX
//
//  Created by YulianMobile on 5/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Realm/Realm.h>

@interface Record : RLMObject

@property NSString *record;

- (id)initWithMantleRecordURL:(NSString *)recordURL;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Record>
RLM_ARRAY_TYPE(Record)
