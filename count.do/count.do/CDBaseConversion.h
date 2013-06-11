//
//  CDBaseConversion.h
//  count.do
//
//  Created by Ali Can Bülbül on 6/11/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDBaseConversion : NSObject
+(NSString*) formatNumber:(NSUInteger)n toBase:(NSUInteger)base;
+(NSString*) formatNumber:(NSUInteger)n usingAlphabet:(NSString*)alphabet;
@end