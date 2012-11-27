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
	float angle;                       ///< for tracking touches
	CGPoint touchOrigin;               ///< for horizontal/vertical tracking
}

/*! The number of segments in the outer band */
@property (nonatomic) int numberOfSegments;

/*! The selected segment */
@property (nonatomic) int selectedSegment;


/*! The image that is drawn behind the knob. May be nil. */
@property (nonatomic, retain) UIImage* backgroundImage;


/*! The image currently being used to draw the knob. */
@property (nonatomic, strong) UIImage* knobImage;


/*!
 * Whether changes in the knob's value generate continuous update events.
 * If NO, the control only sends an action event when the user releases the
 * knob. The default is YES.
 */
@property (nonatomic, assign) BOOL continuous;



@end
