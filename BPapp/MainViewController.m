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

- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains //find where file is
    (NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"bp.sql"]; //find the file, create if doesn't exist
}

- (void)openDB {
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Database Failed to Open");
    } else {
        NSLog(@"db opened");
    }
}

- (void)viewDidLoad
{
    [self openDB];
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

- (IBAction)saveEntry:(id)sender {
    
}
@end
