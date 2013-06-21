//
//  GameViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/19/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "GameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation GameViewController

- (void)setFlipCount:(int)flipCount {
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
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
		
		UIImage *cardBackImage = [UIImage imageNamed:@"card.png"];
		UIImage *blankImage = [[UIImage alloc] init];
		[cardButton setImage:cardBackImage forState:UIControlStateNormal];
		[cardButton setImage:blankImage forState:UIControlStateSelected];
		[cardButton setImage:blankImage forState:UIControlStateSelected|UIControlStateDisabled];
		[cardButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 7, 6)];
	}
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	self.resultsLabel.text = [self.game.history lastObject];
	
	self.historySlider.maximumValue = [self.game.history count] - 1;
	self.resultsLabel.alpha = 1.0;
}

- (IBAction)flipCard:(UIButton *)sender {
	[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.flipCount++;
	[self updateUI];
	[self.historySlider setValue:self.historySlider.maximumValue animated:NO];
}

- (IBAction)browseHistory:(UISlider *)sender {
	self.resultsLabel.text = [self.game.history objectAtIndex:round(sender.value)];
	if (round(sender.value) == sender.maximumValue) {
		self.resultsLabel.alpha = 1.0;
	} else {
		self.resultsLabel.alpha = 0.6;
	}
}

- (IBAction)deal {
	self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
												  usingDeck:[[PlayingCardDeck alloc] init]];
	self.flipCount = 0;
	[self updateUI];
}

@end
