//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Kyle Stevens on 8/26/13.
//  Copyright (c) 2013 Kyle Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic, getter=isFaceUp) BOOL faceUp;

@end
