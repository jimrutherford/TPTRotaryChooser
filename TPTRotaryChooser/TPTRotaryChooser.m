//
//  TPTRotaryChooser.m
//  TPTRotaryChooser
//
//  Created by James Rutherford on 2012-11-26.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import "TPTRotaryChooser.h"
#import <QuartzCore/QuartzCore.h>

const float MAX_ANGLE = 10.0f;
const float MIN_DISTANCE_SQUARED = 16.0f;

@implementation TPTRotaryChooser

@synthesize value;
@synthesize continuous;
@synthesize defaultValue;
@synthesize resetsToDefault;

- (float)angleForValue:(float)theValue
{
	return (theValue - 0.5f) * (MAX_ANGLE*2.0f);
}

- (float)valueForAngle:(float)theAngle
{
	return (theAngle/(MAX_ANGLE*2.0f) + 0.5f);
}

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

- (float)valueForPosition:(CGPoint)point
{
	float delta;
	
	delta = point.x - touchOrigin.x;

	float newAngle = delta + angle;

	return [self valueForAngle:newAngle];
}

- (void)showNormalKnobImage
{
	knobImageView.image = knobImageNormal;
}

- (void)showHighlighedKnobImage
{
	if (knobImageHighlighted != nil)
		knobImageView.image = knobImageHighlighted;
	else
		knobImageView.image = knobImageNormal;
}

- (void)showDisabledKnobImage
{
	if (knobImageDisabled != nil)
		knobImageView.image = knobImageDisabled;
	else
		knobImageView.image = knobImageNormal;
}

- (void)valueDidChangeFrom:(float)oldValue to:(float)newValue animated:(BOOL)animated
{
	// (If you want to do custom drawing, then this is the place to do so.)
	
	float newAngle = [self angleForValue:newValue];
	
	if (animated)
	{
		// We cannot simply use UIView's animations because they will take the
		// shortest path, but we always want to go the long way around. So we
		// set up a keyframe animation with three keyframes: the old angle, the
		// midpoint between the old and new angles, and the new angle.
		
		float oldAngle = [self angleForValue:oldValue];
		
		CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.duration = 0.2f;
		
		animation.values = [NSArray arrayWithObjects:
							[NSNumber numberWithFloat:oldAngle * M_PI/180.0f],
							[NSNumber numberWithFloat:(newAngle + oldAngle)/2.0f * M_PI/180.0f],
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
	value = defaultValue = 0.5f;
	angle = 0.0f;
	continuous = YES;
	resetsToDefault = YES;
	
	knobImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[self addSubview:knobImageView];
	
	[self valueDidChangeFrom:value to:value animated:NO];
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self commonInit];
	}
	return self;
}

- (void)dealloc
{

}

- (UIImage*)backgroundImage
{
	return backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage*)image
{
	if (backgroundImageView == nil)
	{
		backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:backgroundImageView];
		[self sendSubviewToBack:backgroundImageView];
	}
	
	backgroundImageView.image = image;
}

- (UIImage*)foregroundImage
{
	return foregroundImageView.image;
}

- (void)setForegroundImage:(UIImage*)image
{
	if (foregroundImageView == nil)
	{
		foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:foregroundImageView];
		[self bringSubviewToFront:foregroundImageView];
	}
	
	foregroundImageView.image = image;
}

- (UIImage*)currentKnobImage
{
	return knobImageView.image;
}

- (void)setKnobImage:(UIImage*)image forState:(UIControlState)theState
{
	if (theState == UIControlStateNormal)
	{
		if (image != knobImageNormal)
		{
			knobImageNormal = image;
			
			if (self.state == UIControlStateNormal)
			{
				knobImageView.image = image;
				knobImageView.frame = CGRectMake((self.bounds.size.width - image.size.width)/2, (self.bounds.size.height - image.size.height)/2, image.size.width, image.size.height);
				[knobImageView sizeToFit];
			}
		}
	}
	
	if (theState & UIControlStateHighlighted)
	{
		if (image != knobImageHighlighted)
		{
			knobImageHighlighted = image;
			
			if (self.state & UIControlStateHighlighted)
				knobImageView.image = image;
		}
	}
	
	if (theState & UIControlStateDisabled)
	{
		if (image != knobImageDisabled)
		{
			knobImageDisabled = image;
			
			if (self.state & UIControlStateDisabled)
				knobImageView.image = image;
		}
	}
}

- (UIImage*)knobImageForState:(UIControlState)theState
{
	if (theState == UIControlStateNormal)
		return knobImageNormal;
	else if (theState & UIControlStateHighlighted)
		return knobImageHighlighted;
	else if (theState & UIControlStateDisabled)
		return knobImageDisabled;
	else
		return nil;
}

- (void)setValue:(float)newValue
{
	[self setValue:newValue animated:NO];
}

- (void)setValue:(float)newValue animated:(BOOL)animated
{
	float oldValue = value;
	
	value = newValue;
	
	[self valueDidChangeFrom:(float)oldValue to:(float)value animated:animated];
}

- (void)setEnabled:(BOOL)isEnabled
{
	[super setEnabled:isEnabled];
	
	if (!self.enabled)
		[self showDisabledKnobImage];
	else if (self.highlighted)
		[self showHighlighedKnobImage];
	else
		[self showNormalKnobImage];
}

- (BOOL)beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint point = [touch locationInView:self];
	

	// If the touch is too close to the center, we can't calculate a decent
	// angle and the knob becomes too jumpy.
	if ([self squaredDistanceToCenter:point] < MIN_DISTANCE_SQUARED)
		return NO;
	
	// Calculate starting angle between touch and center of control.
	angle = [self angleBetweenCenterAndPoint:point];

	
	self.highlighted = YES;
	[self showHighlighedKnobImage];
	canReset = NO;
	
	return YES;
}

- (BOOL)handleTouch:(UITouch*)touch
{
	if (touch.tapCount > 1 && resetsToDefault && canReset)
	{
		[self setValue:defaultValue animated:YES];
		return NO;
	}
	
	CGPoint point = [touch locationInView:self];
	
	if ([self squaredDistanceToCenter:point] < MIN_DISTANCE_SQUARED)
		return NO;
	
	// Calculate how much the angle has changed since the last event.
	float newAngle = [self angleBetweenCenterAndPoint:point];
	float delta = newAngle - angle;
	angle = newAngle;
	
	self.value +=  delta / (MAX_ANGLE*2.0f);

	
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	if ([self handleTouch:touch] && continuous)
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	
	return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.highlighted = NO;
	[self showNormalKnobImage];
	
	// You can only reset the knob's position if you immediately stop dragging
	// the knob after double-tapping it, i.e. when tracking ends.
	canReset = YES;
	
	[self handleTouch:touch];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent*)event
{
	self.highlighted = NO;
	[self showNormalKnobImage];
}

@end
