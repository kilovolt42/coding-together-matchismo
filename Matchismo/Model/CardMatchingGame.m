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
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
	self = [super init];
	
	if (self) {
		self.cards = nil;
		for (int i = 0; i < cardCount; i++) {
			Card *card = [deck drawRandomCard];
			if (!card) {
				self = nil;
			} else {
				self.cards[i] = card;
			}
		}
		self.deck = deck;
		self.history = [NSMutableArray arrayWithArray:@[@{ @"Type" : @"Blank" }]];
		self.result = [[GameResult alloc] initWithGameTypeKey:[[deck class] description]];
	}
	
	return self;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
	Card *card = [self cardAtIndex:index];
	Card *secondCard = nil;
	int matchScore = 0;
	NSArray *cards;
	
	if (!card.isUnplayable) {
		if (!card.isFaceUp) {
			[self.history addObject:@{ @"Type" : @"Flip", @"Cards" : @[card] }];
			for (Card *otherCard in self.cards) {
				if (otherCard.isFaceUp && !otherCard.isUnplayable) {
					if (self.isThreeCardMode && !secondCard) {
						secondCard = otherCard;
						continue;
					} else if (self.isThreeCardMode) {
						matchScore = [card match:@[secondCard, otherCard]];
						cards = @[card, secondCard, otherCard];
					} else {
						matchScore = [card match:@[otherCard]];
						cards = @[card, otherCard];
					}
					if (matchScore) {
						otherCard.unplayable = YES;
						secondCard.unplayable = YES;
						card.unplayable = YES;
						self.score += matchScore * MATCH_BONUS;
						[self.history addObject:@{ @"Type" : @"Match", @"Cards" : cards, @"Score" : @(matchScore * MATCH_BONUS) }];
					} else {
						otherCard.faceUp = NO;
						secondCard.faceUp = NO;
						self.score -= MISMATCH_PENALTY;
						[self.history addObject:@{ @"Type" : @"Mismatch", @"Cards" : cards, @"Score" : @(MISMATCH_PENALTY) }];
					}
					break;
				}
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

- (void)setScore:(int)score {
	_score = score;
	self.result.score = self.score;
}

- (void)removeCardsAtIndexes:(NSIndexSet *)indexes {
	[self.cards removeObjectsAtIndexes:indexes];
}

- (int)cardsInPlay {
	return [self.cards count];
}

- (int)cardsInDeck {
	return self.deck.count;
}

- (void)dealAdditionalCards:(NSUInteger)cardCount {
	for (int i = 0; i < cardCount; i++) {
		Card *card = [self.deck drawRandomCard];
		if (card) {
			[self.cards addObject:card];
		}
	}
}

@end
