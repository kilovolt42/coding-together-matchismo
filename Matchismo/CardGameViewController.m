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

- (Class)deckClass {
	return [PlayingCardDeck class];
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

@end
