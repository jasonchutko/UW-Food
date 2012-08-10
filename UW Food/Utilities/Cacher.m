//
//  Cacher.m
//  UW Food
//
//  Created by Jason Chutko on 2012-08-06.
//  Copyright (c) 2012 Jason Chutko. All rights reserved.
//

#import "Cacher.h"

@implementation Cacher

+ (void)saveData:(NSData*)data withFileName:(NSString*)filename {
    
    // construct path within our documents directory
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:filename];
    
    // write to file atomically (using temp file)
    [data writeToFile:storePath atomically:TRUE];
}

+ (NSData*)readFile:(NSString*)filename{
    NSData *data;
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    data = [NSData dataWithContentsOfFile:[applicationDocumentsDir stringByAppendingPathComponent:filename]];
    
    return data;
}

@end
