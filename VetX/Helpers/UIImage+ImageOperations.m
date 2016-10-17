//
//  UIImage+ImageOperations.m
//  UNE
//
//  Created by YulianMobile on 12/12/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

#import "UIImage+ImageOperations.h"

@implementation UIImage (ImageOperations)

- (UIImage*)imagescaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
