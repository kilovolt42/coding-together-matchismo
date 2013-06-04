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
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

- (void)setFlipCount:(int)flipCount {
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
	NSLog(@"flips updated to %d", self.flipCount);
}

- (PlayingCardDeck *)deck {
	if (!_deck) _deck = [[PlayingCardDeck alloc] init];
	return _deck;
}

- (IBAction)flipCard:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	self.flipCount++;
	
	if (sender.isSelected) {
		Card *newCard = [self.deck drawRandomCard];
		[sender setTitle:newCard.contents forState:UIControlStateSelected];
	}
}

@end
