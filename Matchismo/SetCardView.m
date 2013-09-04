//
//  SetCardView.m
//  SuperSet
//
//  Created by Kyle Stevens on 8/28/13.
//  Copyright (c) 2013 Kyle Stevens. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define CORNER_RADIUS 12.0
#define PADDING 0.20
#define RATIO 0.5
#define NUMBER_OF_STRIPES 10

- (void)drawRect:(CGRect)rect {
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
	[roundedRect addClip];
	
	if (self.isSelected) {
		[[UIColor colorWithRed:1.0 green:1.0 blue:0.7 alpha:1.0] setFill];
	} else {
		[[UIColor whiteColor] setFill];
	}
	UIRectFill(self.bounds);
	
	[self.color setStroke];
	[self.color setFill];
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	if (self.shading == SetCardShadingStriped) [self addStripesToMutablePath:path];
	
	CGFloat centerX = self.bounds.size.width / 2.0;
	CGFloat centerY = self.bounds.size.height / 2.0;
	
	CGFloat width = self.bounds.size.width * (1 - 2*PADDING);
	CGFloat height = width * RATIO;
	
	CGRect symbolRect;
	
	if (self.number == 1 || self.number == 3) {
		symbolRect = CGRectMake(centerX - width/2, centerY - height/2, width, height);
		[self addSymbolToMutablePath:path inRect:symbolRect];
		if (self.number == 3) {
			symbolRect.origin.y += height + height * PADDING;
			[self addSymbolToMutablePath:path inRect:symbolRect];
			symbolRect.origin.y -= 2 * (height + height * PADDING);
			[self addSymbolToMutablePath:path inRect:symbolRect];
		}
	} else if (self.number == 2) {
		symbolRect = CGRectMake(centerX - width/2, centerY - height - (height * PADDING)/2, width, height);
		[self addSymbolToMutablePath:path inRect:symbolRect];
		symbolRect.origin.y = centerY + (height * PADDING)/2;
		[self addSymbolToMutablePath:path inRect:symbolRect];
	}
	
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
	bezierPath.lineWidth = 2.0;
	
	[bezierPath addClip];
	[bezierPath stroke];
	
	if (self.shading == SetCardShadingSolid) [bezierPath fill];
}

- (void)addSymbolToMutablePath:(CGMutablePathRef)path inRect:(CGRect)rect {
	if (self.symbol == SetCardSymbolDiamond) [self addDiamondToMutablePath:path inRect:rect];
	if (self.symbol == SetCardSymbolSquiggle) [self addSquiggleToMutablePath:path inRect:rect];
	if (self.symbol == SetCardSymbolOval) [self addOvalToMutablePath:path inRect:rect];
}

- (void)addDiamondToMutablePath:(CGMutablePathRef)path inRect:(CGRect)rect {
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	CGPoint center = CGPointMake(rect.origin.x + width/2, rect.origin.y + height/2);
	
	CGPoint left = CGPointMake(center.x - width/2, center.y);
	CGPoint right = CGPointMake(center.x + width/2, center.y);
	CGPoint top = CGPointMake(center.x, center.y + height/2);
	CGPoint bottom = CGPointMake(center.x, center.y - height/2);
	
	CGPathMoveToPoint(path, NULL, left.x, left.y);
	CGPathAddLineToPoint(path, NULL, top.x, top.y);
	CGPathAddLineToPoint(path, NULL, right.x, right.y);
	CGPathAddLineToPoint(path, NULL, bottom.x, bottom.y);
	CGPathCloseSubpath(path);
}

- (void)addSquiggleToMutablePath:(CGMutablePathRef)path inRect:(CGRect)rect {
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height * 2 * PADDING);
	CGPathAddCurveToPoint(path, NULL,
						  rect.origin.x + rect.size.width/2, rect.origin.y - rect.size.height * 3 * PADDING,
						  rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height * 3 * PADDING,
						  rect.origin.x + rect.size.width, rect.origin.y);
	CGPathAddQuadCurveToPoint(path, NULL,
							  rect.origin.x + rect.size.width + rect.size.width * PADDING, rect.origin.y + rect.size.width * PADDING / 2,
							  rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - rect.size.height * 2 * PADDING);
	CGPathAddCurveToPoint(path, NULL,
						  rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height * 3 * PADDING + rect.size.height,
						  rect.origin.x + rect.size.width/2, rect.origin.y - rect.size.height * 3 * PADDING + rect.size.height,
						  rect.origin.x, rect.origin.y + rect.size.height);
	CGPathAddQuadCurveToPoint(path, NULL,
							  rect.origin.x - rect.size.width * PADDING, rect.origin.y + rect.size.height - rect.size.width * PADDING / 2,
							  rect.origin.x, rect.origin.y + rect.size.height * 2 * PADDING);
	CGPathCloseSubpath(path);
}

- (void)addOvalToMutablePath:(CGMutablePathRef)path inRect:(CGRect)rect {
	CGPathAddEllipseInRect(path, NULL, rect);
	CGPathCloseSubpath(path);
}

- (void)addStripesToMutablePath:(CGMutablePathRef)path {
	for (int i = 1; i < NUMBER_OF_STRIPES; i++) {
		CGPathMoveToPoint(path, NULL, self.bounds.size.width/NUMBER_OF_STRIPES*i, 0);
		CGPathAddLineToPoint(path, NULL, self.bounds.size.width/NUMBER_OF_STRIPES*i, self.bounds.size.height);
	}
	CGPathCloseSubpath(path);
}

#pragma mark - Properties

- (void)setNumber:(NSUInteger)number {
	_number = number;
	[self setNeedsDisplay];
}

- (void)setSymbol:(SetCardSymbolType)symbol {
	_symbol = symbol;
	[self setNeedsDisplay];
}

- (void)setShading:(SetCardShadingType)shading {
	_shading = shading;
	[self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
	_color = color;
	[self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;
	[self setNeedsDisplay];
}

#pragma mark - Initialization

- (void)setup {
	
}

- (void)awakeFromNib {
	[self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
