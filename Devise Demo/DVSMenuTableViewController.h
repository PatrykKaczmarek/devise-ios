//
//  DVSMenuTableViewController.h
//  Devise
//
//  Created by Wojciech Trzasko on 09.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const DVSTableModelTitleKey;
extern NSString * const DVSTableModelSubtitleKey;
extern NSString * const DVSTableModelSegueKey;

@interface DVSMenuTableViewController : UITableViewController

- (NSString *)defaultCellId;
- (NSArray *)tableDataSource;

@end
