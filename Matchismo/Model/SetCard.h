//
//  SetCard.h
//  Matchismo
//
//  Created by Kyle Stevens on 6/21/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic) float shade;
@property (nonatomic, strong) UIColor *color;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShades;
+ (NSArray *)validColors;

@end
