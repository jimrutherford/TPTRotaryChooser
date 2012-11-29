//
//  ViewController.h
//  TPTRotaryChooser
//
//  Created by James Rutherford on 2012-11-26.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTRotaryChooser.h"

@interface ViewController : UIViewController <TPTRotaryChooserDelegate>

@property TPTRotaryChooser *rotaryChooser;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end
