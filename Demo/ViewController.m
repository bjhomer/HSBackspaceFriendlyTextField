//
//  ViewController.m
//  HSBackspaceFriendlyTextField
//
//  Created by BJ Homer on 10/29/11.
//  Copyright (c) 2011. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize textField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	textField.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
	[self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (NSEqualRanges(NSMakeRange(0, 0), range) && [string isEqualToString:@""]) {
		NSLog(@"Backward deletion at beginning of text field!");
	}
	return YES;
}
@end
