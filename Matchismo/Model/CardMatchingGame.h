//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Kyle Stevens on 6/5/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameResult.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;
@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong) GameResult *result;
@property (nonatomic, getter=isThreeCardMode) BOOL threeCardMode;
@property (nonatomic) int cardsInPlay;
@property (nonatomic) int cardsInDeck;

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck; // designated initializer
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)removeCardsAtIndexes:(NSIndexSet *)indexes;
- (void)dealAdditionalCards:(NSUInteger)cardCount;

@end
