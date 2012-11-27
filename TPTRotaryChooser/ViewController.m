//
//  ViewController.m
//  TPTRotaryChooser
//
//  Created by James Rutherford on 2012-11-26.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import "ViewController.h"
#import "TPTRotaryChooser.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize rotaryChooser;
@synthesize valueLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	rotaryChooser = [[TPTRotaryChooser alloc] initWithFrame:CGRectMake(200, 200, 400, 400)];
	rotaryChooser.backgroundColor = [UIColor clearColor];
	rotaryChooser.backgroundImage = [UIImage imageNamed:@"background"];
	rotaryChooser.knobImage = [UIImage imageNamed:@"dial"];
	[rotaryChooser addTarget:self action:@selector(rotaryKnobDidChange) forControlEvents:UIControlEventValueChanged];
	
	[self.view addSubview:rotaryChooser];
	
}

- (IBAction)rotaryKnobDidChange
{
	//valueLabel.text = [NSString stringWithFormat:@"%.3f", rotaryChooser.value];
	//slider.value = rotaryKnob.value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
