//
//  FlipsideViewController.h
//  BPapp
//
//  Created by Quang Minh Nguyen on 30/06/2026.
//  Copyright (c) 2026 Quang Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController {
    sqlite3 *db;
}

@property (nonatomic, retain) NSMutableArray *entries;
@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;


- (NSString *) filePath;
- (void) openDB;

- (IBAction)done:(id)sender;

@end
