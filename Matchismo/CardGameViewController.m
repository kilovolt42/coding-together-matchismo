//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/4/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@end

@implementation CardGameViewController

- (Deck *)createDeck {
	return [[PlayingCardDeck alloc] init];
}

- (BOOL)isThreeCardMode {
	return NO;
}

- (void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card {
	UIImage *cardBackImage = [UIImage imageNamed:@"card.png"];
	UIImage *blankImage = [[UIImage alloc] init];
	
	[cardButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 7, 6)];
	[cardButton setImage:cardBackImage forState:UIControlStateNormal];
	[cardButton setImage:blankImage forState:UIControlStateSelected];
	[cardButton setImage:blankImage forState:UIControlStateSelected|UIControlStateDisabled];
	
	[cardButton setTitle:card.contents forState:UIControlStateSelected];
	[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
	
	cardButton.selected = card.isFaceUp;
	cardButton.enabled = !card.isUnplayable;
	cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
}

- (void)updateResultsLabelWithProperties:(NSDictionary *)properties {
	NSString *propertyType = properties[@"Type"];
	
	if ([propertyType isEqualToString:@"Blank"]) {
		self.resultsLabel.text = @"";
		return;
	}
	
	NSArray *cards = properties[@"Cards"];
	Card *firstCard = cards[0], *secondCard, *thirdCard;
	
	if ([propertyType isEqualToString:@"Flip"]) {
		self.resultsLabel.text = [NSString stringWithFormat:@"Flipped up %@", firstCard.contents];
		return;
	}
	
	secondCard = cards[1];
	if ([cards count] > 2) {
		thirdCard = cards[2];
	}
	
	NSNumber *score = properties[@"Score"];
	
	NSString *cardsString;
	if (thirdCard) {
		cardsString = [NSString stringWithFormat:@"%@, %@ and %@", firstCard.contents, secondCard.contents, thirdCard.contents];
	} else {
		cardsString = [NSString stringWithFormat:@"%@ and %@", firstCard.contents, secondCard.contents];
	}
	
	NSString *results;
	if ([propertyType isEqualToString:@"Match"]) {
		results = [NSString stringWithFormat:@"Matched %@ for %d points", cardsString, [score intValue]];
	} else if ([propertyType isEqualToString:@"Mismatch"]) {
		results = [NSString stringWithFormat:@"%@ don't match, %d point penalty", cardsString, [score intValue]];
	}
	
	self.resultsLabel.text = results;
}

@end
