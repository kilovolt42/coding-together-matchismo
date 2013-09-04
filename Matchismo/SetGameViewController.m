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
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (Deck *)createDeck {
	return [[SetCardDeck alloc] init];
}

- (BOOL)isThreeCardMode {
	return YES;
}

- (NSUInteger)startingCardCount {
	return 12;
}

- (BOOL)shouldRemoveUnplayableCards {
	return YES;
}

- (NSUInteger)additionalCardCount {
	return 3;
}

- (NSMutableAttributedString *)attributedStringForSetCard:(SetCard *)card {
	NSDictionary *attributes = @{ NSForegroundColorAttributeName : [card.color colorWithAlphaComponent:card.shade], NSStrokeWidthAttributeName : @-8, NSStrokeColorAttributeName : card.color };
	return [[NSMutableAttributedString alloc] initWithString:card.contents attributes:attributes];
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

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate {
	if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
		SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
		if ([card isKindOfClass:[SetCard class]]) {
			SetCard *setCard = (SetCard *)card;
			setCardView.number = setCard.number;
			setCardView.color = setCard.color;
			setCardView.selected = setCard.isFaceUp;
			setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
			
			if ([setCard.symbol isEqualToString:@"▲"]) {
				setCardView.symbol = SetCardSymbolDiamond;
			} else if ([setCard.symbol isEqualToString:@"■"]) {
				setCardView.symbol = SetCardSymbolSquiggle;
			} else {
				setCardView.symbol = SetCardSymbolOval;
			}
			if (setCard.shade == 1.0) {
				setCardView.shading = SetCardShadingSolid;
			} else if (setCard.shade == 0.0) {
				setCardView.shading = SetCardShadingOpen;
			} else {
				setCardView.shading = SetCardShadingStriped;
			}
		}
	}
}

@end
