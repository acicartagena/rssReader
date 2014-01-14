//
//  RRViewController.h
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRRssFeed.h"

#define RSS_FEED_FETCH_SUCCESS @"rssFeedFetchSuccess"
#define RSS_FEED_FETCH_ERROR @"rssFeedFetchError"

#define RSS_FEED_FETCH_STATUS @"elementsArray"


#if STRATEGY == DELEGATE
@interface RRViewController : UITableViewController <RRRssFeedDelegate>
#else
@interface RRViewController : UITableViewController
#endif

@property (nonatomic,strong) RRRssFeed *feed;

@end
