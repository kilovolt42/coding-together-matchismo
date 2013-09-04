//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Kyle Stevens on 8/31/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
