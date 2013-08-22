//
//  SetCard.m
//  Matchismo
//
//  Created by Kyle Stevens on 6/21/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards {
	int score = 0;
	
	if ([otherCards count] == 2) {
		id firstCard = otherCards[0];
		id secondCard = otherCards[1];
		if ([firstCard isKindOfClass:[SetCard class]] && [secondCard isKindOfClass:[SetCard class]]) {
			SetCard *firstSetCard = (SetCard *)firstCard;
			SetCard *secondSetCard = (SetCard *)secondCard;
			
			BOOL numbersMatch = self.number == firstSetCard.number && self.number == secondSetCard.number;
			BOOL numbersDiffer = self.number != firstSetCard.number && self.number != secondSetCard.number && firstSetCard.number != secondSetCard.number;
			
			BOOL symbolsMatch = [self.symbol isEqualToString:firstSetCard.symbol] && [self.symbol isEqualToString:secondSetCard.symbol];
			BOOL symbolsDiffer = ![self.symbol isEqualToString:firstSetCard.symbol] && ![self.symbol isEqualToString:secondSetCard.symbol] && ![firstSetCard.symbol isEqualToString:secondSetCard.symbol];
			
			BOOL shadesMatch = self.shade == firstSetCard.shade && self.shade == secondSetCard.shade;
			BOOL shadesDiffer = self.shade != firstSetCard.shade && self.shade != secondSetCard.shade && firstSetCard.shade != secondSetCard.shade;
			
			BOOL colorsMatch = [self.color isEqual:firstSetCard.color] && [self.color isEqual:secondSetCard.color];
			BOOL colorsDiffer = ![self.color isEqual:firstSetCard.color] && ![self.color isEqual:secondSetCard.color] && ![firstSetCard.color isEqual:secondSetCard.color];
			
			if ((numbersMatch || numbersDiffer) && (symbolsMatch || symbolsDiffer) && (shadesMatch || shadesDiffer) && (colorsMatch || colorsDiffer)) {
				score = 2;
			}
		}
	}
	
	return score;
}

- (NSString *)contents {
	NSMutableString *contents = [NSMutableString string];
	for (int i = 0; i < self.number; i++) {
		[contents appendString:self.symbol];
	}
	return [contents copy];
}

+ (NSArray *)validNumbers {
	static NSArray *validNumbers = nil;
	if (!validNumbers) validNumbers = @[@1, @2, @3];
	return validNumbers;
}

+ (NSArray *)validSymbols {
	static NSArray *validSymbols = nil;
	if (!validSymbols) validSymbols = @[@"▲", @"●", @"■"];
	return validSymbols;
}

+ (NSArray *)validShades {
	static NSArray *validShades = nil;
	if (!validShades) validShades = @[@0.0, @0.3, @1.0];
	return validShades;
}

+ (NSArray *)validColors {
	static NSArray *validColors = nil;
	if (!validColors) validColors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
	return validColors;
}

@end
