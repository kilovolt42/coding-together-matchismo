//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/4/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardModeSegmentedControl;
@end

@implementation CardGameViewController

- (void)setFlipCount:(int)flipCount {
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
	NSLog(@"flips updated to %d", self.flipCount);
}

- (CardMatchingGame *)game {
	if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
														  usingDeck:[[PlayingCardDeck alloc]init]];
	return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
	_cardButtons = cardButtons;
	[self updateUI];
}

- (void)updateUI {
	for (UIButton *cardButton in self.cardButtons) {
		Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
		[cardButton setTitle:card.contents forState:UIControlStateSelected];
		[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
		cardButton.selected = card.isFaceUp;
		cardButton.enabled = !card.isUnplayable;
		cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
	}
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	self.resultsLabel.text = self.game.results;
	
	if (self.cardModeSegmentedControl.selectedSegmentIndex == 0) {
		self.game.threeCardMode = NO;
	} else {
		self.game.threeCardMode = YES;
	}
}

- (IBAction)flipCard:(UIButton *)sender {
	[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.flipCount++;
	self.cardModeSegmentedControl.enabled = NO;
	[self updateUI];
}

- (IBAction)deal {
	self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
												  usingDeck:[[PlayingCardDeck alloc] init]];
	self.flipCount = 0;
	self.cardModeSegmentedControl.enabled = YES;
	[self updateUI];
}

- (IBAction)changeCardMode:(UISegmentedControl *)sender {
	if (sender.selectedSegmentIndex == 0) {
		self.game.threeCardMode = NO;
	} else {
		self.game.threeCardMode = YES;
	}
}

@end
