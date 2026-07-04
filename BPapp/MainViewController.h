//
//  MainViewController.h
//  BPapp
//
//  Created by Quang Minh Nguyen on 30/06/2026.
//  Copyright (c) 2026 Quang Minh Nguyen. All rights reserved.
//

#import "FlipsideViewController.h"
#import "sqlite3.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
{
    sqlite3 *db;
}
@property (strong, nonatomic) IBOutlet UITextField *systolicText;
@property (strong, nonatomic) IBOutlet UITextField *diatolicText;
@property (strong, nonatomic) IBOutlet UITextField *commentsText;
- (IBAction)saveEntry:(id)sender;
- (NSString *) filePath;
- (void) openDB; // find db in directory, create new if not exist.

// field names: date, sys, dia, comments
- (void) createTable: (NSString *) tableName
        withField1: (NSString *) field1
        withField2: (NSString *) field2
        withField3: (NSString *) field3
        withField4: (NSString *) field4;

@end
