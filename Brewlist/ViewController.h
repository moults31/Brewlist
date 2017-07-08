//
//  ViewController.h
//  Brewlist
//
//  Created by Zac Moulton on 2017-07-07.
//  Copyright © 2017 Zac Moulton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRSheets.h>

@interface ViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRSheetsService *service;


@end
