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

@end

@implementation SetGameViewController

- (Class)deckClass {
	return [SetCardDeck class];
}

- (BOOL)isThreeCardMode {
	return YES;
}

- (void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card {
	SetCard *setCard = (SetCard *)card;
	
	NSDictionary *attributes = @{ NSForegroundColorAttributeName : [setCard.color colorWithAlphaComponent:setCard.shade], NSStrokeWidthAttributeName : @-8, NSStrokeColorAttributeName : setCard.color, NSFontAttributeName : [UIFont systemFontOfSize:21] };
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:setCard.contents attributes:attributes];
	
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

@end
