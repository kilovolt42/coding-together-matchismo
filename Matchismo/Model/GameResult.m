//
//  GameResult.m
//  Matchismo
//
//  Created by Kyle Stevens on 8/24/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "GameResult.h"

@interface GameResult ()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@property (nonatomic, strong) NSString *gameTypeKey;
@end

@implementation GameResult

#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

+ (NSArray *)gameResultsForGameTypeKey:(NSString *)gameTypeKey {
	NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
	
	for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:gameTypeKey] allValues]) {
		GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
		result.gameTypeKey = gameTypeKey;
		[allGameResults addObject:result];
	}
	
	return allGameResults;
}

// designated initializer
- (id)initWithGameTypeKey:(NSString *)gameTypeKey {
	self = [self init];
	if (self) {
		_gameTypeKey = gameTypeKey;
	}
	return self;
}

// convenience initializer
- (id)initFromPropertyList:(id)plist {
	self = [self init];
	if (self) {
		if ([plist isKindOfClass:[NSDictionary class]]) {
			NSDictionary *resultDictionary = (NSDictionary *)plist;
			_start = resultDictionary[START_KEY];
			_end = resultDictionary[END_KEY];
			_score = [resultDictionary[SCORE_KEY] intValue];
			if (!_start || !_end) self = nil;
		}
	}
	return self;
}

- (void)synchronize {
	NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:self.gameTypeKey] mutableCopy];
	if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
	mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
	[[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:self.gameTypeKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList {
	return @{ START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score) };
}

- (NSTimeInterval)duration {
	return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score {
	_score = score;
	self.end = [NSDate date];
	if (!self.start) self.start = self.end;
	[self synchronize];
}

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult {
	if (self.score > otherResult.score) {
		return NSOrderedAscending;
	} else if (self.score < otherResult.score) {
		return NSOrderedDescending;
	} else {
		return NSOrderedSame;
	}
}

- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult {
	return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult {
	if (self.duration > otherResult.duration) {
		return NSOrderedDescending;
	} else if (self.duration < otherResult.duration) {
		return NSOrderedAscending;
	} else {
		return NSOrderedSame;
	}
}

@end
