//
//  MainViewController.m
//  BPapp
//
//  Created by Quang Minh Nguyen on 30/06/2026.
//  Copyright (c) 2026 Quang Minh Nguyen. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize systolicText, diastolicText, commentsText; // generate "setters" & "getters" for property

- (IBAction)hyperlink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/quangmng/BPapp/tree/no-stringWithFormat"]];
}

// filepath to bp's db
- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains //find where file is
    (NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"]; //find the file, create if doesn't exist
}

// open db
- (void)openDB {
    if (sqlite3_open([[self filePath] UTF8String], &db) == SQLITE_OK) {
        NSLog(@"db opened");
    } else {
        //sqlite3_close(db);
        NSAssert(0, @"Database Failed to Open: %s", sqlite3_errmsg(db));
    }
}


- (IBAction)saveEntry:(id)sender {
    int systolic = [systolicText.text intValue];
    int diastolic = [diastolicText.text intValue];
    NSString *comments = commentsText.text;
    NSDate *theDate = [NSDate date];
    
    // formatting Date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:theDate];
    
    const char *appendBP = "INSERT INTO summary(date, systolic, diastolic, comments) VALUES (?, ?, ?, ?);";
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(db, appendBP, -1, &stmt, NULL ) == SQLITE_OK) {
        // binding things in order
        sqlite3_bind_text(stmt, 1, [dateString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(stmt, 2, systolic);
        sqlite3_bind_int64(stmt, 3, diastolic);
        sqlite3_bind_text(stmt, 4, [comments UTF8String], -1, SQLITE_TRANSIENT);
        
        // execute statement
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            NSLog(@"Table updated successfully!");
        } else {
            NSLog(@"Failed to execute: %s", sqlite3_errmsg(db));
        }
    sqlite3_finalize(stmt);
    
    // clear text after saving
    systolicText.text = @"";
    diastolicText.text = @"";
    commentsText.text = @"";
    
    // dismiss keyboard
    [self.view endEditing:YES];
    
    } else {
        
        NSLog(@"Could not prepare statement: %s", sqlite3_errmsg(db));
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self openDB];
    const char *sql = "CREATE TABLE IF NOT EXISTS summary (id INTEGER PRIMARY KEY, "
    "date TEXT, "
    "systolic INTEGER, "
    "diastolic INTEGER, "
    "comments TEXT);";
    
    char *err;
    if (sqlite3_exec(db, sql, NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"Failed to create table: %s", err);
        sqlite3_free(err);
    } else {
        NSLog(@"Table 'summary' verified successfully.");
    }
    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}


@end
