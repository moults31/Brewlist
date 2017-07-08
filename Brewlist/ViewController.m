//
//  ViewController.m
//  Brewlist
//
//  Created by Zac Moulton on 2017-07-07.
//  Copyright © 2017 Zac Moulton. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure Google Sign-in.
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeSheetsSpreadsheetsReadonly, nil];
    [signIn signInSilently];
    
    // Add the sign-in button.
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.view addSubview:self.signInButton];
    
    // Create a UITextView to display output.
    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.output.editable = false;
    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.output.hidden = true;
    [self.view addSubview:self.output];
    
    // Initialize the service object.
    self.service = [[GTLRSheetsService alloc] init];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.output.hidden = false;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        [self listMajors];
    }
}

// Display (in the UITextView) the names and majors of students in a sample
// spreadsheet:
// https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
// https://docs.google.com/spreadsheets/d/1MHv7TovqKZ9lCJsW_P3zzymR4uAGufp8Ek8meyi-sGY/edit
- (void)listMajors {
    self.output.text = @"Getting sheet data...";
    //NSString *spreadsheetId = @"1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms";
    NSString *spreadsheetId = @"1MHv7TovqKZ9lCJsW_P3zzymR4uAGufp8Ek8meyi-sGY";
    //NSString *range = @"Class Data!A2:E";
    NSString *range = @"Class Data!A2:B";
    
    GTLRSheetsQuery_SpreadsheetsValuesGet *query =
    [GTLRSheetsQuery_SpreadsheetsValuesGet queryWithSpreadsheetId:spreadsheetId
                                                            range:range];
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRSheets_ValueRange *)result
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *output = [[NSMutableString alloc] init];
        NSArray *rows = result.values;
        if (rows.count > 0) {
            [output appendString:@"Name, Major:\n"];
            for (NSArray *row in rows) {
                // Print columns A and E, which correspond to indices 0 and 4.
                [output appendFormat:@"%@, %@\n", row[0], row[1]];
                //[output appendFormat:@"%@\n", row[0]];
            }
        } else {
            [output appendString:@"No data found."];
        }
        self.output.text = output;
    } else {
        NSMutableString *message = [[NSMutableString alloc] init];
        [message appendFormat:@"Error getting sheet data: %@\n", error.localizedDescription];
        [self showAlert:@"Error" message:message];
    }
}


// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
