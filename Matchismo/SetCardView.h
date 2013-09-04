//
//  SetCardView.h
//  SuperSet
//
//  Created by Kyle Stevens on 8/28/13.
//  Copyright (c) 2013 Kyle Stevens. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	SetCardSymbolDiamond,
	SetCardSymbolSquiggle,
	SetCardSymbolOval
} SetCardSymbolType;

typedef enum {
	SetCardShadingSolid,
	SetCardShadingStriped,
	SetCardShadingOpen
} SetCardShadingType;

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardSymbolType symbol;
@property (nonatomic) SetCardShadingType shading;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, getter=isSelected) BOOL selected;

@end
