//
//  AESCrypt.h
//  Linq
//
//  Created by spencerdezartsmith on 8/16/16.
//  Copyright © 2016 Linq Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESCrypt : NSObject

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
