//
//  GameResult.h
//  Matchismo
//
//  Created by Kyle Stevens on 8/24/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

+ (NSArray *)gameResultsForGameTypeKey:(NSString *)gameTypeKey;

- (id)initWithGameTypeKey:(NSString *)gameTypeKey; // designated initializer
- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult;

@end
