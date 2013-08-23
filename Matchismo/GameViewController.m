//
//  GameViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/19/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "GameViewController.h"
#import "CardMatchingGame.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (nonatomic) Class deckClass;
@property (nonatomic, getter=isThreeCardMode) BOOL threeCardMode;
@end

@implementation GameViewController

- (void)setFlipCount:(int)flipCount {
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (CardMatchingGame *)game {
	if (!_game) {
		_game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[self.deckClass alloc]init]];
		_game.threeCardMode = self.isThreeCardMode;
	}
	return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
	_cardButtons = cardButtons;
	[self updateUI];
}

- (void)updateUI {
	for (UIButton *cardButton in self.cardButtons) {
		Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
		[self updateCardButton:cardButton forCard:card];
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	[self updateResultsLabelWithProperties:[self.game.history lastObject]];
	
	self.historySlider.maximumValue = [self.game.history count] - 1;
	self.resultsLabel.alpha = 1.0;
}

- (void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card {
	// implemented by subclasses
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

- (IBAction)flipCard:(UIButton *)sender {
	[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.flipCount++;
	[self updateUI];
	[self.historySlider setValue:self.historySlider.maximumValue animated:NO];
}

- (IBAction)browseHistory:(UISlider *)sender {
	[self updateResultsLabelWithProperties:[self.game.history objectAtIndex:round(sender.value)]];
	if (round(sender.value) == sender.maximumValue) {
		self.resultsLabel.alpha = 1.0;
	} else {
		self.resultsLabel.alpha = 0.6;
	}
}

- (IBAction)deal {
	self.game = nil;
	self.flipCount = 0;
	[self updateUI];
}

@end
