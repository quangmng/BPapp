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
@property (strong, nonatomic) IBOutlet UITextField *diastolicText;
@property (strong, nonatomic) IBOutlet UITextField *commentsText;
- (IBAction)saveEntry:(id)sender;
- (NSString *) filePath;
- (IBAction)hyperlink:(id)sender;
- (void) openDB; // find db in directory, create new if not exist.

@end
