//
//  DVSFormTableViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 11.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVSFormTableViewController : UITableViewController

- (void)addFormWithTitleToDataSource:(NSString *)title;
- (void)addFormWithTitleToDataSource:(NSString *)title secured:(BOOL)secured;
- (NSString *)getValueForTitle:(NSString *)title;

@end
