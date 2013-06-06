//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Kyle Stevens on 6/5/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck; // designated initializer
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
