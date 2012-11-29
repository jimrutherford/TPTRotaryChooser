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

@synthesize colorRotaryChooser;
@synthesize bgRotaryChooser;

@synthesize quoteLabel;
@synthesize authorLabel;
@synthesize bgImageView;

NSArray *colors;
NSArray *backgrounds;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	
	colors = @[[UIColor colorWithRed:0.93f green:0.94f blue:0.94f alpha:1.00f],
			  [UIColor colorWithRed:0.28f green:0.47f blue:1.00f alpha:1.00f],
			  [UIColor colorWithRed:1.00f green:0.78f blue:0.00f alpha:1.00f],
			  [UIColor colorWithRed:0.73f green:0.00f blue:0.74f alpha:1.00f],
			  [UIColor colorWithRed:0.03f green:0.73f blue:0.00f alpha:1.00f],
			  [UIColor colorWithRed:1.00f green:0.00f blue:0.00f alpha:1.00f]
			  ];
	
	backgrounds = @[[UIImage imageNamed:@"pattern"],
	[UIImage imageNamed:@"wood"],
	[UIImage imageNamed:@"fabric"],
	[UIImage imageNamed:@"quilt"],
	[UIImage imageNamed:@"grate"],
	[UIImage imageNamed:@"leather"]
	];
	
	colorRotaryChooser = [[TPTRotaryChooser alloc] initWithFrame:CGRectMake(20, 20, 250, 250)];
	colorRotaryChooser.backgroundColor = [UIColor clearColor];
	colorRotaryChooser.numberOfSegments = 6;
	colorRotaryChooser.selectedSegment = 0;
	colorRotaryChooser.delegate = self;
	colorRotaryChooser.backgroundImage = [UIImage imageNamed:@"colorDialBackground"];
	colorRotaryChooser.knobImage = [UIImage imageNamed:@"dial"];
	colorRotaryChooser.tag = 100;
	
	self.quoteLabel.textColor = [colors objectAtIndex:colorRotaryChooser.selectedSegment];
		
	
	bgRotaryChooser = [[TPTRotaryChooser alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 250 - 20, 250, 250)];
	bgRotaryChooser.backgroundColor = [UIColor clearColor];
	bgRotaryChooser.numberOfSegments = 6;
	bgRotaryChooser.selectedSegment = 0;
	bgRotaryChooser.delegate = self;
	bgRotaryChooser.backgroundImage = [UIImage imageNamed:@"textureDialBackground"];
	bgRotaryChooser.knobImage = [UIImage imageNamed:@"dial"];
	bgRotaryChooser.tag	= 200;
	
	
	[self.view addSubview:colorRotaryChooser];
	[self.view addSubview:bgRotaryChooser];
}


- (void)rotaryChooserDidChangeSelectedSegment:(TPTRotaryChooser *)chooser
{
	NSLog(@"changing");
	if (chooser.tag == 100)
	{
		self.quoteLabel.textColor = [colors objectAtIndex:colorRotaryChooser.currentSegment];
		self.authorLabel.textColor = [colors objectAtIndex:colorRotaryChooser.currentSegment];
	}
}

- (void)rotaryChooserDidSelectedSegment:(TPTRotaryChooser *)chooser
{
	NSLog(@"selected");
	if (chooser.tag == 100)
	{
		self.quoteLabel.textColor = [colors objectAtIndex:colorRotaryChooser.selectedSegment];
		self.authorLabel.textColor = [colors objectAtIndex:colorRotaryChooser.selectedSegment];
	}
	else if (chooser.tag == 200)
	{
		self.bgImageView.image = [backgrounds objectAtIndex:bgRotaryChooser.selectedSegment];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
