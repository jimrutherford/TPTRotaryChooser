//
//  TPTRotaryChooser.h
//  TPTRotaryChooser
//
//  Created by James Rutherford on 2012-11-26.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTRotaryChooser : UIControl {
	UIImageView* backgroundImageView;  ///< shows the background image
	UIImageView* foregroundImageView;  ///< shows the foreground image
	UIImageView* knobImageView;        ///< shows the knob image
	UIImage* knobImageNormal;          ///< knob image for normal state
	UIImage* knobImageHighlighted;     ///< knob image for highlighted state
	UIImage* knobImageDisabled;        ///< knob image for disabled state
	float angle;                       ///< for tracking touches
	CGPoint touchOrigin;               ///< for horizontal/vertical tracking
	BOOL canReset;                     ///< prevents reset while still dragging
}


/*! The image that is drawn behind the knob. May be nil. */
@property (nonatomic, retain) UIImage* backgroundImage;

/*!
 * The image that is drawn on top of the knob. May be nil. This is useful
 * for partially transparent overlays to make shadow or highlight effects.
 */
@property (nonatomic, strong) UIImage* foregroundImage;

/*! The image currently being used to draw the knob. */
@property (nonatomic, retain, readonly) UIImage* currentKnobImage;

/*! The control's current value. Default is 0.5f (center position). */
@property (nonatomic, assign) float value;

/*! The control's default value. Default is 0.5f (center position). */
@property (nonatomic, assign) float defaultValue;

/*!
 * Whether the control resets to the default value on a double tap.
 * Default is YES.
 */
@property (nonatomic, assign) BOOL resetsToDefault;

/*!
 * Whether changes in the knob's value generate continuous update events.
 * If NO, the control only sends an action event when the user releases the
 * knob. The default is YES.
 */
@property (nonatomic, assign) BOOL continuous;

/*!
 * Sets the controls’s current value, allowing you to animate the change
 * visually.
 */
- (void)setValue:(float)value animated:(BOOL)animated;

/*!
 * Assigns a knob image to the specified control states.
 *
 * This image should have its position indicator at the top. The knob image is
 * rotated when the control's value changes, so it's best to make it perfectly
 * round.
 */
- (void)setKnobImage:(UIImage*)image forState:(UIControlState)state;

/*!
 * Returns the thumb image associated with the specified control state.
 */
- (UIImage*)knobImageForState:(UIControlState)state;

@end
