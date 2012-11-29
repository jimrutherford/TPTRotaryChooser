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
@synthesize quoteLabel;
@synthesize authorLabel;

NSArray *colors;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	
	colors = @[[UIColor colorWithRed:1.00f green:0.00f blue:0.00f alpha:1.00f],
			  [UIColor colorWithRed:0.28f green:0.47f blue:1.00f alpha:1.00f],
			  [UIColor colorWithRed:1.00f green:0.78f blue:0.00f alpha:1.00f],
			  [UIColor colorWithRed:0.73f green:0.00f blue:0.74f alpha:1.00f],
			  [UIColor colorWithRed:0.03f green:0.73f blue:0.00f alpha:1.00f],
			  [UIColor colorWithRed:0.93f green:0.94f blue:0.94f alpha:1.00f]
			  ];
	
	
	rotaryChooser = [[TPTRotaryChooser alloc] initWithFrame:CGRectMake(20, 20, 250, 250)];
	rotaryChooser.backgroundColor = [UIColor clearColor];
	rotaryChooser.numberOfSegments = 6;
	rotaryChooser.selectedSegment = 1;
	rotaryChooser.delegate = self;
	rotaryChooser.backgroundImage = [UIImage imageNamed:@"background"];
	rotaryChooser.knobImage = [UIImage imageNamed:@"dial"];
	
	self.quoteLabel.textColor = [colors objectAtIndex:rotaryChooser.selectedSegment];
		
	[self.view addSubview:rotaryChooser];
	
}


- (void)rotaryChooserDidChangeSelectedSegment:(TPTRotaryChooser *)chooser
{
	NSLog(@"changing");
}

- (void)rotaryChooserDidSelectedSegment:(TPTRotaryChooser *)chooser
{
	NSLog(@"selected");
	self.quoteLabel.textColor = [colors objectAtIndex:rotaryChooser.selectedSegment];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
