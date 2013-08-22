//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/21/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init {
	self = [super init];
	
	if (self) {
		for (id number in [SetCard validNumbers]) {
			for (NSString *symbol in [SetCard validSymbols]) {
				for (id shade in [SetCard validShades]) {
					for (UIColor *color in [SetCard validColors]) {
						SetCard *card = [[SetCard alloc] init];
						card.number = ((NSNumber *)number).unsignedIntValue;
						card.symbol = symbol;
						card.shade = ((NSNumber *)shade).floatValue;
						card.color = color;
						[self addCard:card atTop:YES];
					}
				}
			}
		}
	}
	
	return self;
}

@end
