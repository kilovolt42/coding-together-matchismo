//
//  PlayingCard.h
//  Matchismo
//
//  Created by Kyle Stevens on 6/4/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
