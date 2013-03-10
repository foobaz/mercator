//
//  MercatorFilter.h
//  Mercator
//
//  Created by William MacKay on 3/10/13.
//  Copyright (c) 2013 William MacKay. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface MercatorFilter : CIFilter {
    CIImage      *inputImage;
    CIVector     *inputCenter;
    NSNumber     *inputWidth;
    NSNumber     *inputAmount;
}

@end
