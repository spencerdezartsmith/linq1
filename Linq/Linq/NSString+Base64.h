//
//  NSString+Base64.h
//  Linq
//
//  Created by spencerdezartsmith on 8/16/16.
//  Copyright © 2016 Linq Team. All rights reserved.
//

#import <Foundation/NSString.h>

@interface NSString (Base64Additions)

+ (NSString *)base64StringFromData:(NSData *)data length:(NSUInteger)length;

@end

