//
//  MercatorPlugInLoader.h
//  Mercator
//
//  Created by William MacKay on 3/10/13.
//  Copyright (c) 2013 William MacKay. All rights reserved.
//

#import <QuartzCore/CoreImage.h>

@interface MercatorPlugInLoader : NSObject <CIPlugInRegistration>

- (BOOL)load:(void *)host;

@end
