//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/5/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
	self = [super init];
	
	if (self) {
		for (int i = 0; i < cardCount; i++) {
			Card *card = [deck drawRandomCard];
			if (!card) {
				self = nil;
			} else {
				self.cards[i] = card;
			}
		}
	}
	
	return self;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
	Card *card = [self cardAtIndex:index];
	
	if (!card.isUnplayable) {
		if (!card.isFaceUp) {
			for (Card *otherCard in self.cards) {
				if (otherCard.isFaceUp && !otherCard.isUnplayable) {
					int matchScore = [card match:@[otherCard]];
					if (matchScore) {
						otherCard.unplayable = YES;
						card.unplayable = YES;
						self.score += matchScore * MATCH_BONUS;
						self.results = [NSString stringWithFormat:@"Matched %@ and %@ for %d points",
											card.contents,
											otherCard.contents,
											MATCH_BONUS];
					} else {
						otherCard.faceUp = NO;
						self.score -= MISMATCH_PENALTY;
						self.results = [NSString stringWithFormat:@"%@ and %@ don't match, %d point penalty",
										card.contents,
										otherCard.contents,
										MISMATCH_PENALTY];
					}
					break;
				}
				self.results = [NSString stringWithFormat:@"Flipped up %@", card.contents];
			}
			self.score -= FLIP_COST;
		}
		card.faceUp = !card.faceUp;
	}
}

- (Card *)cardAtIndex:(NSUInteger)index {
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSMutableArray *)cards {
	if (!_cards) _cards = [[NSMutableArray alloc] init];
	return _cards;
}

@end
