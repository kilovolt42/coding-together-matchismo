//
//  GameViewController.h
//  Matchismo
//
//  Created by Kyle Stevens on 6/19/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (nonatomic, getter=isThreeCardMode) BOOL threeCardMode;

- (Deck *)createDeck;
- (void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card;
- (void)updateResultsLabelWithProperties:(NSDictionary *)properties;

@end
