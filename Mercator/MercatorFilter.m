//
//  MercatorFilter.m
//  Mercator
//
//  Created by William MacKay on 3/10/13.
//  Copyright (c) 2013 William MacKay. All rights reserved.
//

#import "MercatorFilter.h"
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@implementation MercatorFilter

static CIKernel *_MercatorFilterKernel = nil;

- (id)init
{
    if(!_MercatorFilterKernel) {
		NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"MercatorFilter")];
		NSStringEncoding encoding = NSUTF8StringEncoding;
		NSError     *error = nil;
		NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"MercatorFilterKernel" ofType:@"cikernel"] encoding:encoding error:&error];
		NSArray     *kernels = [CIKernel kernelsWithString:code];

		_MercatorFilterKernel = kernels[0];
    }
    return [super init];
}

- (CGRect)regionOf:(int)sampler  destRect:(CGRect)rect  userInfo:(id)userInfo
{
	return rect;
}

- (NSArray *)inputKeys {
	return [NSArray
		   arrayWithObjects:
		   @"inputImage", @"alpha", @"beta", @"gamma", @"aspect", nil
		   ];
}

- (NSDictionary *)customAttributes
{
	return @{
		@"alpha":@{
		  kCIAttributeMin:@-M_PI,
    kCIAttributeMax:@M_PI,
    kCIAttributeSliderMin:@-M_PI,
    kCIAttributeSliderMax:@M_PI,
    kCIAttributeDefault:@0,
    kCIAttributeIdentity:@0,
    kCIAttributeType:kCIAttributeTypeAngle,
    },
  @"beta":@{
		  kCIAttributeMin:@-M_PI,
    kCIAttributeMax:@M_PI,
    kCIAttributeSliderMin:@-M_PI,
    kCIAttributeSliderMax:@M_PI,
    kCIAttributeDefault:@0,
    kCIAttributeIdentity:@0,
    kCIAttributeType:kCIAttributeTypeAngle,
    },
  @"gamma":@{
		  kCIAttributeMin:@-M_PI,
    kCIAttributeMax:@M_PI,
    kCIAttributeSliderMin:@-M_PI,
    kCIAttributeSliderMax:@M_PI,
    kCIAttributeDefault:@0,
    kCIAttributeIdentity:@0,
    kCIAttributeType:kCIAttributeTypeAngle,
    },
  @"aspect":@{
		  kCIAttributeMin:@0,
    kCIAttributeSliderMin:@0,
    kCIAttributeSliderMax:@4,
    kCIAttributeDefault:@2,
    kCIAttributeIdentity:@1,
    kCIAttributeType:kCIAttributeTypeScalar,
    },
  };
}

// called when setting up for fragment program and also calls fragment program
- (CIImage *)outputImage
{
	CISampler *src = [CISampler samplerWithImage:inputImage];
//	double alphaDouble = [alpha doubleValue];
//	double betaDouble = [beta doubleValue];
//	double gammaDouble = [gamma doubleValue];
	double aspectFloat = [aspect floatValue];
	CGRect extent = inputImage.extent;
	double width = extent.size.width;
	double oldHeight = extent.size.height;
	double newHeight = width / aspectFloat;

	return [self apply:
		   _MercatorFilterKernel,
		   src,
		   [NSNumber numberWithDouble:width],
		   [NSNumber numberWithDouble:oldHeight],
		   [NSNumber numberWithDouble:newHeight],
		   kCIApplyOptionExtent,
		   [NSArray arrayWithObjects:
		    (NSNumber *)kCFBooleanFalse,
		    (NSNumber *)kCFBooleanFalse,
//		    [NSNumber numberWithFloat:oldHeight - newHeight],
//		    [NSNumber numberWithFloat:(oldHeight - newHeight) * 0.5f],
		    [NSNumber numberWithDouble:width],
		    [NSNumber numberWithDouble:newHeight],
		    nil
		    ],
		   nil
		   ];
}

@end
