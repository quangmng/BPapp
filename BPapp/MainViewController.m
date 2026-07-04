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
    // declaring table
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "TEXT PRIMARY KEY, '%@' INTEGER, '%@' INTEGER, '%@' TEXT);", tableName, field1, field2, field3, field4];
    // create table
    if (sqlite3_exec(db, [sql UTF8String] , NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not create table.");
    } else {
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
    

    NSString *appendBP = [NSString stringWithFormat:@"INSERT INTO summary('theDate', 'systolic', 'diastolic', 'comments') VALUES ('%@', '%d', '%d', '%s')", theDate, systolic, diastolic, [comments UTF8String]];
    
    char *err;
    if (sqlite3_exec(db, [appendBP UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not update table: %s", err);
    } else {
        NSLog(@"Table updated");
    }
    systolicText.text = @"";
    diastolicText.text = @"";
    commentsText.text = @"";

    
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
