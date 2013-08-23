//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/19/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@end

@implementation SetGameViewController

- (Class)deckClass {
	return [SetCardDeck class];
}

- (BOOL)isThreeCardMode {
	return YES;
}

- (NSMutableAttributedString *)attributedStringForSetCard:(SetCard *)card {
	NSDictionary *attributes = @{ NSForegroundColorAttributeName : [card.color colorWithAlphaComponent:card.shade], NSStrokeWidthAttributeName : @-8, NSStrokeColorAttributeName : card.color };
	return [[NSMutableAttributedString alloc] initWithString:card.contents attributes:attributes];
}

- (void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card {
	NSMutableAttributedString *attributedString = [self attributedStringForSetCard:(SetCard *)card];
	[attributedString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:21] } range:NSMakeRange(0, [attributedString length])];
	
	[cardButton setAttributedTitle:attributedString forState:UIControlStateNormal];
	[cardButton setAttributedTitle:attributedString forState:UIControlStateSelected];
	[cardButton setAttributedTitle:attributedString forState:UIControlStateSelected|UIControlStateDisabled];
	
	cardButton.selected = card.isFaceUp;
	cardButton.enabled = !card.isUnplayable;
	cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;
	
	[cardButton setBackgroundColor:[UIColor whiteColor]];
	if (cardButton.selected) {
		[cardButton setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
	}
}

- (void)updateResultsLabelWithProperties:(NSDictionary *)properties {
	NSString *propertyType = properties[@"Type"];
	
	if ([propertyType isEqualToString:@"Blank"]) {
		self.resultsLabel.text = @"";
		return;
	}
	
	NSArray *cards = properties[@"Cards"];
	SetCard *firstCard = cards[0], *secondCard, *thirdCard;
	NSAttributedString *firstCardAttributedString = [self attributedStringForSetCard:firstCard], *secondCardAttributedString, *thirdCardAttributedString;
	NSMutableAttributedString *results;
	
	if ([propertyType isEqualToString:@"Flip"]) {
		results = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
		[results appendAttributedString:[self attributedStringForSetCard:firstCard]];
		self.resultsLabel.attributedText = results;
		return;
	}
	
	secondCard = cards[1];
	secondCardAttributedString = [self attributedStringForSetCard:secondCard];
	if ([cards count] > 2) {
		thirdCard = cards[2];
		thirdCardAttributedString = [self attributedStringForSetCard:thirdCard];
	}
	
	NSNumber *score = properties[@"Score"];
	
	NSMutableAttributedString *cardsString;
	if (thirdCard) {
		cardsString = [[NSMutableAttributedString alloc] initWithAttributedString:firstCardAttributedString];
		[cardsString appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
		[cardsString appendAttributedString:secondCardAttributedString];
		[cardsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" and "]];
		[cardsString appendAttributedString:thirdCardAttributedString];
	} else {
		cardsString = [[NSMutableAttributedString alloc] initWithAttributedString:firstCardAttributedString];
		[cardsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" and "]];
		[cardsString appendAttributedString:secondCardAttributedString];
	}
	
	if ([propertyType isEqualToString:@"Match"]) {
		results = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
		[results appendAttributedString:cardsString];
		[results appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", [score intValue]]]];
	} else if ([propertyType isEqualToString:@"Mismatch"]) {
		results = [[NSMutableAttributedString alloc] initWithAttributedString:cardsString];
		[results appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match, %d point penalty", [score intValue]]]];
	}
	
	[results addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17] } range:NSMakeRange(0, [results length])];
	
	self.resultsLabel.attributedText = results;
}

@end
