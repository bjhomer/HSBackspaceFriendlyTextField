//
//  MyTextField.m
//  HSBackspaceFriendlyTextField
//
//  Created by BJ Homer on 10/29/11.
//  Copyright (c) 2011. All rights reserved.
//

#import "HSBackspaceFriendlyTextField.h"
#import <objc/runtime.h>

#if __has_feature(objc_arc)
  #error "This class must be compiled without ARC because objc_allocateClassPair() doesn't like ARC"
#endif

static NSString * const SubclassName = @"HSBackspaceNotifyingFieldEditor";

static void *BackwardDeleteTargetKey = &BackwardDeleteTargetKey;


@implementation HSBackspaceFriendlyTextField

- (void)my_willDeleteBackward {
	
	// Check if the cursor is at the start of the field.
	UITextRange *selectedRange = self.selectedTextRange;
	if (selectedRange.empty && [selectedRange.start isEqual:self.beginningOfDocument]) {
		
		// We're reusing the existing delegate method, since that's where other keypress events
		// on a UITextField are usually tracked. Note that since no actual change is being made,
		// we're ignoring the return value.
		if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
			[self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
		}
	}
}

- (BOOL)becomeFirstResponder {
	BOOL shouldBecome = [super becomeFirstResponder];
	if (shouldBecome == NO) {
		return NO;
	}
	
	Class myFieldEditorClass = objc_lookUpClass([SubclassName UTF8String]);
	if (myFieldEditorClass == nil) {
		Class uiFieldEditorClass = objc_lookUpClass("UIFieldEditor");
		
		if (uiFieldEditorClass) {
			// Register the new class
			myFieldEditorClass = objc_allocateClassPair(uiFieldEditorClass, [SubclassName UTF8String], 0);
			objc_registerClassPair(myFieldEditorClass);
			
			// Add the new deleteBackward implementation
			IMP fieldEditor_deleteBackwardIMP = [self methodForSelector:@selector(fieldEditor_deleteBackward)];
			Method fieldEditor_deleteBackwardMethod = class_getInstanceMethod(myFieldEditorClass, 
																			  @selector(fieldEditor_deleteBackward));
			const char *types = method_getTypeEncoding(fieldEditor_deleteBackwardMethod);
			
			class_addMethod(myFieldEditorClass, @selector(deleteBackward), fieldEditor_deleteBackwardIMP, types);
		}
	}
	
	id fieldEditor = [self valueForKey:@"fieldEditor"];
	
	if (fieldEditor && myFieldEditorClass) {
		object_setClass(fieldEditor, myFieldEditorClass);
		objc_setAssociatedObject(fieldEditor, BackwardDeleteTargetKey, self, OBJC_ASSOCIATION_ASSIGN);
	}
	
	return YES;
}

- (BOOL)resignFirstResponder {
	BOOL shouldResign =  [super resignFirstResponder];
	if (shouldResign == NO) {
		return NO;
	}
	
	id fieldEditor = [self valueForKey:@"fieldEditor"];
					  
	if (fieldEditor) {
		objc_setAssociatedObject(fieldEditor, BackwardDeleteTargetKey, nil, OBJC_ASSOCIATION_ASSIGN);
		Class uiFieldEditorClass = objc_lookUpClass("UIFieldEditor");
		if (uiFieldEditorClass) {
			object_setClass(fieldEditor, uiFieldEditorClass);
		}
	}
	return YES;
}

- (void)fieldEditor_deleteBackward {
	
	HSBackspaceFriendlyTextField *textField = objc_getAssociatedObject(self, BackwardDeleteTargetKey);
	[textField my_willDeleteBackward];
	
	Class superclass = class_getSuperclass([self class]);
	SEL deleteBackwardSEL = @selector(deleteBackward);
	IMP superIMP = [superclass instanceMethodForSelector:deleteBackwardSEL];
	superIMP(self, deleteBackwardSEL);
}

@end
