//
//  TPTRotaryChooser.m
//  TPTRotaryChooser
//
//  Created by James Rutherford on 2012-11-26.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import "TPTRotaryChooser.h"
#import <QuartzCore/QuartzCore.h>

const float MIN_DISTANCE_SQUARED = 16.0f;

@implementation TPTRotaryChooser

@synthesize continuous;
@synthesize numberOfSegments;
@synthesize selectedSegment;
@synthesize currentSegment;


CGPoint lastTouchLocation;
BOOL dragging;
int oldSegment;

- (float)angleBetweenCenterAndPoint:(CGPoint)point
{
	CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	
	// Yes, the arguments to atan2() are in the wrong order. That's because our
	// coordinate system is turned upside down and rotated 90 degrees. :-)
	float theAngle = atan2(point.x - center.x, center.y - point.y) * 180.0f/M_PI;
	
	return theAngle;
}

- (float)squaredDistanceToCenter:(CGPoint)point
{
	CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return dx*dx + dy*dy;
}

- (void)angleDidChangeFrom:(float)oldAngle to:(float)newAngle animated:(BOOL)animated
{
	// (If you want to do custom drawing, then this is the place to do so.)
		
	if (dragging)
	{
		if (newAngle > 180)
		{
			newAngle = (360-newAngle) * -1;
		}
	}
	if (animated)
	{
		// We are going to animate between three keyframes in order to
		// make sure we are animating between the shortest points
		// start by getting a point in the middle of our start and end
		float midpoint = (newAngle + oldAngle)/2.0f;

		
		// if we are animating between taps let's get the shortest
		// distance to animate between
		if (!dragging) {
			float diff = fabsf(newAngle - oldAngle);
			if (diff > 180)
			{
				midpoint = midpoint - 180;
				if (newAngle>oldAngle)
				{
					newAngle = (360-newAngle) * -1;
				}
				else
				{
					oldAngle = (360-oldAngle) * -1;
				}
				}
		}
			
		CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.duration = 0.2f;
		
		animation.values = [NSArray arrayWithObjects:
							[NSNumber numberWithFloat:oldAngle * M_PI/180.0f],
					[NSNumber numberWithFloat:midpoint * M_PI/180.0f],
							[NSNumber numberWithFloat:newAngle * M_PI/180.0f],
							nil];
		
		animation.keyTimes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:0.0f],
							  [NSNumber numberWithFloat:0.5f],
							  [NSNumber numberWithFloat:1.0f],
							  nil];
		
		animation.timingFunctions = [NSArray arrayWithObjects:
									 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
									 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
									 nil];
		
		[knobImageView.layer addAnimation:animation forKey:nil];
	}
	
	knobImageView.transform = CGAffineTransformMakeRotation(newAngle * M_PI/180.0f);
}

- (void)commonInit
{
	angle = 0.0f;
	continuous = YES;
	
	knobImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[self addSubview:knobImageView];
}

-(id) init
{
	if (self = [super init])  {
		// init some properties to sentinal values
		oldSegment = -1;
		self.selectedSegment = -1;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self commonInit];
	}
	return self;
}

#pragma mark -
#pragma mark Selected Item Handling

- (void) setSelectedSegment:(int)newSelectedSegment
{
	int oldSelectedSegment = selectedSegment;

	CGFloat newAngle = [self angleForSegment:newSelectedSegment];
	
	if(selectedSegment == -1)
	{
		// control is being drawn for the first time, no need to animate
		[self angleDidChangeFrom:(float)0.0f to:(float)newAngle animated:NO];
	}
	else
	{
		if (!dragging)
		{
			CGFloat oldAngle = [self angleForSegment:oldSelectedSegment];
			[self angleDidChangeFrom:(float)oldAngle to:(float)newAngle animated:YES];
		}
		else
		{
			[self angleDidChangeFrom:(float)angle to:(float)newAngle animated:YES];
		}
	}

	selectedSegment = newSelectedSegment;
}



-(CGFloat) angleForSegment:(int)segment
{
	float segments = [[NSNumber numberWithInt: numberOfSegments] floatValue];
	float anglePerSegment = 360.0f/segments;
	
	// adding one as our selected segment is zero based
	return (segment * anglePerSegment) + (anglePerSegment/2);
	
}

- (int) currentSegmentForAngle:(float)theAngle
{
	int segment = 0;

	// get the angle as a range between 0 and 360
	float actualAngle = theAngle;
	
	if (angle < 0)
	{
		actualAngle = 360.0f + theAngle;
	}
	
	// translate the angle into slice
	float totalSegments = [[NSNumber numberWithInt: numberOfSegments] floatValue];
	float anglePerSegment = 360.0f/totalSegments;
	
	for (float a = 0; a < totalSegments; a++) {
		float currentAngle = a * anglePerSegment;
		float nextAngle = (a + 1) *anglePerSegment;
		
		if (actualAngle > currentAngle && actualAngle < nextAngle)
		{
			segment = [[NSNumber numberWithFloat:a] intValue];
			break;
		}
	}
	return segment;
}


#pragma mark -
#pragma mark Touch Handling

- (BOOL)beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	lastTouchLocation = [touch locationInView:self];
	dragging = NO;
	
	return YES;
}

- (BOOL)handleTouch:(UITouch*)touch
{
	CGPoint point = [touch locationInView:self];
	
	if ([self squaredDistanceToCenter:point] < MIN_DISTANCE_SQUARED)
		return NO;
	// Calculate how much the angle has changed since the last event.
	float oldAngle = angle;
	float newAngle = [self angleBetweenCenterAndPoint:point];
	
	if (dragging)
	{
		[self angleDidChangeFrom:(float)oldAngle to:(float)newAngle animated:NO];		
	}
	angle = newAngle;
	
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	dragging = YES;
	if ([self handleTouch:touch] && continuous)
	{	
		self.currentSegment = [self currentSegmentForAngle:angle];
		
		if (self.currentSegment != oldSegment)
		{
			// fire off delegate message
			SEL rotaryChooserDidChangeSelectedSegmentSelector = @selector(rotaryChooserDidChangeSelectedSegment:);
			if (self.delegate && [self.delegate respondsToSelector:rotaryChooserDidChangeSelectedSegmentSelector]) {
				[self.delegate rotaryChooserDidChangeSelectedSegment:(TPTRotaryChooser*)self];
			}
			oldSegment = self.currentSegment;
		}
	}
	return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	[self handleTouch:touch];
		
	self.currentSegment = [self currentSegmentForAngle:angle];
	self.selectedSegment = self.currentSegment;
	
	// fire off delegate message
	SEL rotaryChooserDidSelectedSegmentSelector = @selector(rotaryChooserDidSelectedSegment:);
	if (self.delegate && [self.delegate respondsToSelector:rotaryChooserDidSelectedSegmentSelector]) {
		[self.delegate rotaryChooserDidSelectedSegment:(TPTRotaryChooser*)self];
	}
	
	dragging = NO;
}

#pragma mark -
#pragma mark Getters/Setters
- (UIImage*)backgroundImage
{
	return backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage*)image
{
	if (backgroundImageView == nil)
	{
		backgroundImageView = [[UIImageView alloc] init];
		backgroundImageView.frame = CGRectMake((self.bounds.size.width - image.size.width)/2, (self.bounds.size.height - image.size.height)/2, image.size.width, image.size.height);
		[self addSubview:backgroundImageView];
		[self sendSubviewToBack:backgroundImageView];
	}
	
	backgroundImageView.image = image;
}

- (void)setKnobImage:(UIImage*)image 
{
	knobImageView.image = image;
	knobImageView.frame = CGRectMake((self.bounds.size.width - image.size.width)/2, (self.bounds.size.height - image.size.height)/2, image.size.width, image.size.height);
	[knobImageView sizeToFit];
}

@end
