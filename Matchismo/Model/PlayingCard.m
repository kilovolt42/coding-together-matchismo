//
//  PlayingCard.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/4/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents {
	NSArray *rankStrings = [PlayingCard rankStrings];
	return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits {
	static NSArray *validSuits = nil;
	if (!validSuits) validSuits = @[@"♥", @"♦", @"♠", @"♣"];
	return validSuits;
}

+ (NSArray *)rankStrings {
	static NSArray *rankStrings = nil;
	if (!rankStrings) rankStrings = @[@"?", @"A", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"J", @"Q", @"K"];
	return rankStrings;
}

+ (NSUInteger)maxRank {
	return [self rankStrings].count - 1;
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
	if ([[PlayingCard validSuits] containsObject:suit]) {
		_suit = suit;
	}
}

- (NSString *)suit {
	return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
	if (rank <= [PlayingCard maxRank]) {
		_rank = rank;
	}
}

@end
