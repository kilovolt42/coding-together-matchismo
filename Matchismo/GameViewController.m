//
//  GameViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/19/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "GameViewController.h"
#import "CardMatchingGame.h"

@interface GameViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation GameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.game.cardsInPlay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
	Card *card = [self.game cardAtIndex:indexPath.item];
	[self updateCell:cell usingCard:card animate:NO];
	return cell;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY];
	if ([settings[DEAL_ON_TAB_KEY] boolValue]) {
		[self deal];
	}
}

- (CardMatchingGame *)game {
	if (!_game) {
		_game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
		_game.threeCardMode = self.isThreeCardMode;
	}
	return _game;
}

- (void)updateUI {
	for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
		NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
		Card *card = [self.game cardAtIndex:indexPath.item];
		[self updateCell:cell usingCard:card animate:NO];
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	[self updateResultsLabelWithProperties:[self.game.history lastObject]];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
	CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
	NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
	Card *card = [self.game cardAtIndex:indexPath.item];
	if (indexPath && !card.isUnplayable) {
		[self.game flipCardAtIndex:indexPath.item];
		[self updateCell:[self.cardCollectionView cellForItemAtIndexPath:indexPath] usingCard:card animate:YES];
		[self updateUI];
		if (self.shouldRemoveUnplayableCards) [self removeUnplayableCards];
	}
}

- (void)removeUnplayableCards {
	NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
	NSMutableArray *indexPathArray = [NSMutableArray arrayWithArray:@[]];
	
	for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
		NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
		Card *card = [self.game cardAtIndex:indexPath.item];
		if (card.isUnplayable) {
			[indexSet addIndex:indexPath.item];
			[indexPathArray addObject:indexPath];
		}
	}
	
	[self.game removeCardsAtIndexes:indexSet];
	[self.cardCollectionView deleteItemsAtIndexPaths:indexPathArray];
}

- (IBAction)deal {
	self.game = nil;
	[self.cardCollectionView reloadData];
	[self updateUI];
}

#pragma mark Abstract Methods

- (Deck *)createDeck {
	return nil;
}

- (void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card {
}

- (void)updateResultsLabelWithProperties:(NSDictionary *)properties {
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate {
}

@end
