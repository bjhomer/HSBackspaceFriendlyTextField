//
//  ViewController.h
//  HSBackspaceFriendlyTextField
//
//  Created by BJ Homer on 10/29/11.
//  Copyright (c) 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBackspaceFriendlyTextField.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet HSBackspaceFriendlyTextField *textField;

@end
