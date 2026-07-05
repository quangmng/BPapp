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

- (void) createTable: (NSString *) tableName
          withField1: (NSString *) field1
          withField2: (NSString *) field2
          withField3: (NSString *) field3
          withField4: (NSString *) field4 {
    // declaring table (safely)
    const char *createTable = "CREATE TABLE IF NOT EXISTS '%@' ('%@' "
    "TEXT PRIMARY KEY, '%@' INTEGER, '%@' INTEGER, '%@' TEXT);";
    sqlite3_stmt *stmt;
    // create table
    if (sqlite3_prepare_v2(db, createTable, -1, &stmt, NULL ) == SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"Could not create table: %s", sqlite3_errmsg(db));
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"Table created");
    }
}
// filepath to bp's db
- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains //find where file is
    (NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"]; //find the file, create if doesn't exist
}

// open db
- (void)openDB {
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Database Failed to Open");
    } else {
        NSLog(@"db opened");
    }
}


- (IBAction)saveEntry:(id)sender {
    int systolic = [systolicText.text intValue];
    int diastolic = [diastolicText.text intValue];
    NSString *comments = commentsText.text;
    NSDate *theDate = [NSDate date];
    
    // formatting shortDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:theDate];
    
    const char *appendBP = "INSERT INTO summary(theDate, systolic, diastolic, comments) VALUES (?, ?, ?, ?);";
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(db, appendBP, -1, &stmt, NULL ) == SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"Could not update table: %s", sqlite3_errmsg(db));
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"Table updated");
    }
    
    // binding things in order 
    sqlite3_bind_text(stmt, 1, [dateString UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(stmt, 2, systolic);
    sqlite3_bind_int64(stmt, 3, diastolic);
    sqlite3_bind_text(stmt, 4, [comments UTF8String], -1, SQLITE_TRANSIENT);
    
    // clear text after saving
    systolicText.text = @"";
    diastolicText.text = @"";
    commentsText.text = @"";
    
    // dismiss keyboard
    [self.view endEditing:YES];
    
}

- (void)viewDidLoad
{
    [self openDB];
    [self createTable:@"summary" withField1:@"theDate" withField2:@"systolic" withField3:@"diastolic" withField4:@"comments"];
    [super viewDidLoad];
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
