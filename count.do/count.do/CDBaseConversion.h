//
//  CDBaseConversion.h
//  count.do
//
//  Created by Ali Can Bülbül on 6/11/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDBaseConversion : NSObject
+(NSString*) formatNumber:(long long)n toBase:(NSUInteger)base;
+(NSString*) formatNumber:(long long)n usingAlphabet:(NSString*)alphabet;
+(long long)decode62:(NSString*)string;
@end