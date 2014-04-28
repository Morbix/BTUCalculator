//
//  NSString+Common.h
//  BTU-Calc-Air-Conditioner
//
//  Created by HP Developer on 27/04/14.
//  Copyright (c) 2014 Morbix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

-(BOOL)isBlank;
-(BOOL)contains:(NSString *)string;
-(NSArray *)splitOnChar:(char)ch;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
-(NSString *)stringByStrippingWhitespace;

@end
