//
//  FlipsideViewController.m
//  BPapp
//
//  Created by Quang Minh Nguyen on 30/06/2026.
//  Copyright (c) 2026 Quang Minh Nguyen. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController
@synthesize entries;

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

- (IBAction)toggleEditMode:(UIBarButtonItem *)sender {
    // Check if table is in edit mode
    if (self.tableView.isEditing) {
        // Turn edit mode OFF
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"Edit";
        sender.style = UIBarButtonItemStyleBordered; 
    } else {
        // Turn edit mode ON
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"Done";
        sender.style = UIBarButtonItemStyleDone;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // init the arrays
    entries = [[NSMutableArray alloc] init];
    self.entryIDs = [[NSMutableArray alloc] init];
    
    [self openDB];
    const char *readDB = "SELECT * FROM summary";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(db, readDB, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            int recordID = sqlite3_column_int(statement, 0);
            [self.entryIDs addObject:@(recordID)]; // Save the ID as an NSNumber
            
            char *field1 = (char *) sqlite3_column_text(statement, 1);
            NSString *field1Str = [[NSString alloc]initWithUTF8String:field1];
            
            char *field2 = (char *) sqlite3_column_text(statement, 2);
            NSString *field2Str = [[NSString alloc]initWithUTF8String:field2];
            
            char *field3 = (char *) sqlite3_column_text(statement, 3);
            NSString *field3Str = [[NSString alloc]initWithUTF8String:field3];
            
            char *field4 = (char *) sqlite3_column_text(statement, 4);
            NSString *field4Str = [[NSString alloc]initWithUTF8String:field4];
            
            // shortened date (no time)
            NSString *shortDate = field1Str;
            if (field1Str.length >= 10) {
                shortDate = [field1Str substringToIndex:10];
            }
            
            // data formatting per cell
            NSString *str = [[NSString alloc]initWithFormat:@"%@ - %@/%@ - %@", shortDate, field2Str, field3Str, field4Str];
            [entries addObject:str ];
        }
        sqlite3_finalize(statement);
    }
    NSLog(@"Entries found: %lu", (unsigned long)[entries count]);

    [self.tableView reloadData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return no. of entries in section
    return [entries count];
    NSLog(@"%d", [entries count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // ID the cells to Storyboard
    static NSString *cellIdentifier = @"BPrecord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell data
    cell.textLabel.text = [self.entries objectAtIndex:indexPath.row];
    return cell;
}

// Edit mode - deleting entry
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Get ID of row swiped on
        NSNumber *rowID = [self.entryIDs objectAtIndex:indexPath.row];
        
        // Delete record from database
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM summary WHERE id = %d", [rowID intValue]];
        
        char *err;
        if (sqlite3_exec(db, [deleteQuery UTF8String], NULL, NULL, &err) == SQLITE_OK) {
            
            // If deletion successful, remove data from arrays
            [self.entries removeObjectAtIndex:indexPath.row];
            [self.entryIDs removeObjectAtIndex:indexPath.row];
            
            // Animate cell disappearing
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            NSLog(@"Failed to delete record: %s", err);
            sqlite3_free(err);
        }
    }
}

@end
