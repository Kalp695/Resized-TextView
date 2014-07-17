//
//  ViewController.m
//  textView
//
//  Created by Kalpit Gajera on 2014/07/17.
//  Copyright (c) 2014 Kalpit Gajera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGRect originalTextViewFrame;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    originalHeight = CGRectGetHeight(_textView.frame);
    originalTextViewFrame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up
{
  /*  NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    animationCurve = animationCurve<<16;//ios7からの変更
    
    
    CGRect newFrame = _textView.frame;

    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];

    if (up) {
        newFrame.size.height = originalHeight - CGRectGetHeight(keyboardEndFrame);//NO bar
     //   newFrame.size.height = originalHeight - CGRectGetHeight(keyboardEndFrame)-CGRectGetHeight(_textBar.frame);
    } else{
        //newFrame.size.height += CGRectGetHeight(keyboardEndFrame)//NO bar
        newFrame.size.height += CGRectGetHeight(keyboardEndFrame)+CGRectGetHeight(_textBar.frame);
    }
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         _textView.frame = newFrame;
                         //bar exist
                         _textView.contentSize=CGSizeMake(newFrame.size.width, newFrame.size.height);
                         _textBar.frame = CGRectMake(0, _textView.frame.size.height, CGRectGetWidth(_textBar.frame), CGRectGetHeight(_textBar.frame));
                     }
                     completion:^(BOOL finished) {
                         
                     }];*/
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (up == YES) {
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect newTextViewFrame = _textView.frame;
        originalTextViewFrame = _textView.frame;
        newTextViewFrame.size.height = keyboardTop - _textView.frame.origin.y - 10;
        
        _textView.frame = newTextViewFrame;
    } else {
        // Keyboard is going away (down) - restore original frame
        _textView.frame = originalTextViewFrame;
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (IBAction)textBtn:(id)sender {
    [_textView resignFirstResponder];
}
@end
