//
//  ScoresViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 8/24/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "ScoresViewController.h"
#import "GameResult.h"
#import "PlayingCardDeck.h"
#import "SetCardDeck.h"

@interface ScoresViewController ()
@property (weak, nonatomic) IBOutlet UITextView *cardScoresDisplay;
@property (weak, nonatomic) IBOutlet UITextView *setScoresDisplay;
@property (nonatomic) SEL sortSelector;
@end

@implementation ScoresViewController

- (void)updateUI {
	NSString *displayText = @"";
	int rank = 1;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	for (GameResult *result in [[GameResult gameResultsForGameTypeKey:[PlayingCardDeck description]] sortedArrayUsingSelector:self.sortSelector]) {
		displayText = [displayText stringByAppendingFormat:@"%d. Score: %d (%@, %0g sec)\n", rank++,  result.score, [dateFormatter stringFromDate:result.end], round(result.duration)];
	}
	
	self.cardScoresDisplay.text = displayText;
	displayText = @"";
	rank = 1;
	
	for (GameResult *result in [[GameResult gameResultsForGameTypeKey:[SetCardDeck description]] sortedArrayUsingSelector:self.sortSelector]) {
		displayText = [displayText stringByAppendingFormat:@"%d. Score: %d (%@, %0g sec)\n", rank++, result.score, [dateFormatter stringFromDate:result.end], round(result.duration)];
	}
	
	self.setScoresDisplay.text = displayText;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateUI];
}

- (SEL)sortSelector {
	if (!_sortSelector) _sortSelector = @selector(compareScoreToGameResult:);
	return _sortSelector;
}

- (IBAction)sortOrderChanged:(UISegmentedControl *)sender {
	switch (sender.selectedSegmentIndex) {
		case 0: self.sortSelector = @selector(compareScoreToGameResult:); break;
		case 1: self.sortSelector = @selector(compareEndDateToGameResult:); break;
		case 2: self.sortSelector = @selector(compareDurationToGameResult:); break;
		default: break;
	}
	[self updateUI];
}

@end
