//
//  Constants.h
//  VetX
//
//  Created by YulianMobile on 12/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_LANDSCAPE                    ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight || UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))

// To Draw a 1 pixel
#define SINGLE_LINE_WIDTH               (1/[UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET       ((1/[UIScreen mainScreen].scale)/2)

// Since we disable landscape, width and height should not change
#define SCREEN_HEIGHT                   (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH                    (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.width)
#define TABBAT_HEIGHT                   49.0f

#define BUTTON_TEXT_COLOR               [UIColor colorWithRed:0.556  green:0.556  blue:0.556 alpha:1]
#define BUTTON_BACKGROUND_COLOR         [UIColor colorWithRed:0.893  green:0.893  blue:0.893 alpha:1]
#define BLACK_SEARCH_MENU_FONT          [UIColor colorWithRed:0.089  green:0.089  blue:0.089 alpha:1]
#define SEARCH_MENU_COLOR               [UIColor colorWithRed:0.925  green:0.925  blue:0.928 alpha:1]
#define TAB_BAR_UNSELECTED_COLOR        [UIColor colorWithRed:0.292  green:0.292  blue:0.292 alpha:1]
#define ORANGE_THEME_COLOR              [UIColor colorWithRed:1 green:0.522 blue:0.016 alpha:1]
#define APP_THEME_COLOR_LIGHT           [UIColor colorWithRed:255.0/255.0 green:192.0/255.0 blue:147.0/255.0 alpha:1.0]
#define GREY_COLOR                      [UIColor colorWithRed:0.690  green:0.690  blue:0.690 alpha:1]
#define DARK_GREY_COLOR                 [UIColor colorWithRed:0.596  green:0.596  blue:0.596 alpha:1]
#define FEED_BACKGROUND_COLOR           [UIColor colorWithRed:0.953  green:0.953  blue:0.953 alpha:1]
#define FEED_CELL_SHADOW                [UIColor colorWithRed:0.878  green:0.878  blue:0.878 alpha:1]
#define LIGHT_GREY_COLOR                [UIColor colorWithRed:0.925  green:0.925  blue:0.924 alpha:1]
#define REGERRAL_CODE_COLOR             [UIColor colorWithRed:0.663 green:0.663 blue:0.663 alpha:1]
#define NAVIGATION_BACKGROUND_COLOR     [UIColor colorWithRed:0.937  green:0.937  blue:0.937 alpha:1]
#define FB_BACKGROUND_COLOR             [UIColor colorWithRed:0.235  green:0.349  blue:0.596 alpha:1]
#define FEED_CELL_TITLE_COLOR           [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1]
#define FEED_CELL_NAME_COLOR            [UIColor colorWithRed:0.549 green:0.576 blue:0.604 alpha:1]
#define POST_QUESTION_BACKGROUND        [UIColor colorWithRed:0.969  green:0.969  blue:0.969 alpha:1]
#define SEARCH_TEXTFIELD_BACKGROUND     [UIColor colorWithRed:0.925 green:0.482 blue:0.016 alpha:1]
#define TEXTFIELD_BORDER_COLOR          [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1]
#define MEDICAL_RECOR_COLOR             [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1]
#define MEDICAL_PET_NAME_COLOR          [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1]
#define EMPTY_VIEW_TEXT_COLOR           [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]


//!!!: Colors below may change in the future
#define NEW_COLOR_1                     [UIColor colorWithRed:0.004  green:0.573  blue:0.624 alpha:1]

#define VETX_FONT_LIGHT_8             [UIFont fontWithName:@"GothamHTF-Light" size:8.0f]
#define VETX_FONT_LIGHT_13            [UIFont fontWithName:@"GothamHTF-Light" size:13.0f]
#define VETX_FONT_LIGHT_14            [UIFont fontWithName:@"GothamHTF-Light" size:14.0f]
#define VETX_FONT_LIGHT_24            [UIFont fontWithName:@"GothamHTF-Light" size:24.0f]

#define VETX_FONT_ITALIC_11             [UIFont fontWithName:@"GothamHTF-Italic" size:11.0f]
#define VETX_FONT_REGULAR_11            [UIFont fontWithName:@"GothamHTF-Book" size:11.0f]
#define VETX_FONT_REGULAR_12            [UIFont fontWithName:@"GothamHTF-Book" size:12.0f]
#define VETX_FONT_REGULAR_13            [UIFont fontWithName:@"GothamHTF-Book" size:13.0f]
#define VETX_FONT_REGULAR_14            [UIFont fontWithName:@"GothamHTF-Book" size:14.0f]
#define VETX_FONT_REGULAR_15            [UIFont fontWithName:@"GothamHTF-Book" size:15.0f]
#define VETX_FONT_REGULAR_22            [UIFont fontWithName:@"GothamHTF-Book" size:22.0f]
#define VETX_FONT_REGULAR_24            [UIFont fontWithName:@"GothamHTF-Book" size:24.0f]
#define VETX_FONT_REGULAR_42            [UIFont fontWithName:@"GothamHTF-Book" size:42.0f]

#define VETX_FONT_MEDIUM_8              [UIFont fontWithName:@"GothamHTF-Medium" size:8.0f]
#define VETX_FONT_MEDIUM_9              [UIFont fontWithName:@"GothamHTF-Medium" size:9.0f]
#define VETX_FONT_MEDIUM_10             [UIFont fontWithName:@"GothamHTF-Medium" size:10.0f]
#define VETX_FONT_MEDIUM_11             [UIFont fontWithName:@"GothamHTF-Medium" size:11.0f]
#define VETX_FONT_MEDIUM_12             [UIFont fontWithName:@"GothamHTF-Medium" size:12.0f]
#define VETX_FONT_MEDIUM_13             [UIFont fontWithName:@"GothamHTF-Medium" size:13.0f]
#define VETX_FONT_MEDIUM_14             [UIFont fontWithName:@"GothamHTF-Medium" size:14.0f]
#define VETX_FONT_MEDIUM_15             [UIFont fontWithName:@"GothamHTF-Medium" size:15.0f]
#define VETX_FONT_MEDIUM_17             [UIFont fontWithName:@"GothamHTF-Medium" size:17.0f]
#define VETX_FONT_MEDIUM_22             [UIFont fontWithName:@"GothamHTF-Medium" size:22.0f]
#define VETX_FONT_MEDIUM_32             [UIFont fontWithName:@"GothamHTF-Medium" size:32.0f]

#define VETX_FONT_BOLD_10               [UIFont fontWithName:@"GothamHTF-Bold" size:10.0f]
#define VETX_FONT_BOLD_11               [UIFont fontWithName:@"GothamHTF-Bold" size:11.0f]
#define VETX_FONT_BOLD_12               [UIFont fontWithName:@"GothamHTF-Bold" size:12.0f]
#define VETX_FONT_BOLD_13               [UIFont fontWithName:@"GothamHTF-Bold" size:13.0f]
#define VETX_FONT_BOLD_15               [UIFont fontWithName:@"GothamHTF-Bold" size:15.0f]
#define VETX_FONT_BOLD_20               [UIFont fontWithName:@"GothamHTF-Bold" size:20.0f]
#define VETX_FONT_BOLD_25               [UIFont fontWithName:@"GothamHTF-Bold" size:25.0f]
#define VETX_FONT_BOLD_30               [UIFont fontWithName:@"GothamHTF-Bold" size:30.0f]


#endif /* Constants_h */
