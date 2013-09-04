//
//  PlayingCard.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/4/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
	int score = 0;
	
	if ([otherCards count] == 1) {
		id otherCard = [otherCards lastObject];
		if ([otherCard isKindOfClass:[PlayingCard class]]) {
			PlayingCard *otherPlayingCard = (PlayingCard *)otherCard;
			if ([otherPlayingCard.suit isEqualToString:self.suit]) {
				score = 1;
			} else if (otherPlayingCard.rank == self.rank) {
				score = 4;
			}
		}
	} else if ([otherCards count] == 2) {
		id firstCard = otherCards[0];
		id secondCard = otherCards[1];
		if ([firstCard isKindOfClass:[PlayingCard class]] && [secondCard isKindOfClass:[PlayingCard class]]) {
			PlayingCard *firstPlayingCard = (PlayingCard *)firstCard;
			PlayingCard *secondPlayingCard = (PlayingCard *)secondCard;
			if ([firstPlayingCard.suit isEqualToString:self.suit] &&
				[secondPlayingCard.suit isEqualToString:self.suit]) {
				score = 3;
			} else if (firstPlayingCard.rank == self.rank && secondPlayingCard.rank == self.rank) {
				score = 6;
			}
		}
	}
	
	return score;
}

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
	if (!rankStrings) rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
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
