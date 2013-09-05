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
#import "SetCardView.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *activeCardsView;
@property (strong, nonatomic) NSMutableArray *activeCards;
@end

@implementation SetGameViewController

- (NSMutableArray *)activeCards {
	if (!_activeCards) _activeCards = [[NSMutableArray alloc] init];
	return _activeCards;
}

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
		self.resultsLabel.text = @" ";
		self.activeCards = nil;
		[self updateActiveCardsView];
		return;
	}
	
	NSArray *cards = properties[@"Cards"];
	SetCard *firstCard = cards[0], *secondCard, *thirdCard;
	
	if ([propertyType isEqualToString:@"FlipUp"]) {
		self.resultsLabel.text = @"";
		[self.activeCards addObject:firstCard];
		[self updateActiveCardsView];
		return;
	} else if ([propertyType isEqualToString:@"FlipDown"]) {
		self.resultsLabel.text = @"";
		[self.activeCards removeObject:firstCard];
		[self updateActiveCardsView];
		return;
	}
	
	secondCard = cards[1];
	self.activeCards = [NSMutableArray arrayWithArray:@[firstCard, secondCard]];
	if ([cards count] > 2) {
		thirdCard = cards[2];
		[self.activeCards addObject:thirdCard];
	}
	
	NSNumber *score = properties[@"Score"];
	if ([propertyType isEqualToString:@"Match"]) {
		self.resultsLabel.text = [NSString stringWithFormat:@"Matched for %d points", [score intValue]];
		[self updateActiveCardsView];
		self.activeCards = nil;
	} else if ([propertyType isEqualToString:@"Mismatch"]) {
		self.resultsLabel.text = [NSString stringWithFormat:@"Mismatch, %d point penalty", [score intValue]];
		[self updateActiveCardsView];
		self.activeCards = nil;
	}
}

- (void)updateActiveCardsView {
	NSMutableArray *subviews = [[NSMutableArray alloc] init];
	for (UIView *subview in self.activeCardsView.subviews) {
		[subviews addObject:subview];
	}
	for (UIView *subview in subviews) {
		[subview removeFromSuperview];
	}
	
	CGFloat height = self.activeCardsView.bounds.size.height;
	CGFloat width = 0.7*height;
	
	for (int i = 0; i < [self.activeCards count]; i++) {
		SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(i*width + 0.1*i*width, 0, width, height)];
		setCardView.backgroundColor = [UIColor clearColor];
		[self setupSetCardView:setCardView usingSetCard:self.activeCards[i]];
		[self.activeCardsView addSubview:setCardView];
	}
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate {
	if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
		SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
		if ([card isKindOfClass:[SetCard class]]) {
			SetCard *setCard = (SetCard *)card;
			[self setupSetCardView:setCardView usingSetCard:setCard];
			setCardView.selected = setCard.isFaceUp;
			setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
		}
	}
}

- (void)setupSetCardView:(SetCardView *)setCardView usingSetCard:(SetCard *)setCard {
	setCardView.number = setCard.number;
	setCardView.color = setCard.color;
	
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

@end
