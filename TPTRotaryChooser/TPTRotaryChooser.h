//
//  TPTRotaryChooser.h
//  TPTRotaryChooser
//
//  Created by James Rutherford on 2012-11-26.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPTRotaryChooser;

@protocol TPTRotaryChooserDelegate <NSObject>

- (void)rotaryChooserDidSelectedSegment:(TPTRotaryChooser *)chooser;

@optional
- (void)rotaryChooserDidChangeSelectedSegment:(TPTRotaryChooser *)chooser;


@end

@interface TPTRotaryChooser : UIControl {
	UIImageView* backgroundImageView;  
	UIImageView* foregroundImageView;  
	UIImageView* knobImageView;        
	float angle;                       
}

@property (nonatomic, weak) id <TPTRotaryChooserDelegate> delegate;

/*! The number of segments in the outer band */
@property (nonatomic) int numberOfSegments;

/*! The selected segment */
@property (nonatomic) int selectedSegment;

/*! The current segment - this property updates while the control is dragging */
@property (nonatomic) int currentSegment;


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
