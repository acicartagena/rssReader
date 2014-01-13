//
//  RRRssFeed.h
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRRssEntryCell.h"
#import "RRAppDelegate.h"

@protocol RRRssFeedDelegate <NSObject>

@required
-(void) rssFeedFetchSuccess;
-(void) rssFeedFetchError:(NSError *)error;

@optional
-(void) rssFeedFetchFail;
-(void) rssFeedFetchCancel;

@end

@interface RRRssFeed : NSObject<NSXMLParserDelegate>{
    NSString *title;
    NSString *description;
    NSString *link;
    NSString *pubDate;
    NSString *media;
    NSDictionary *temp;
    NSMutableString *currentElementValue;
    
}

@property (nonatomic,strong) NSMutableArray *elementsArray;
@property (nonatomic,weak) id<RRRssFeedDelegate> delegate;

#if STRATEGY == BLOCKS
-(void) fetchData:(void(^)(void))onSuccess OnError:(void(^)(NSError *))errorMethod;
#elif STRATEGY == DELEGATE
-(void) fetchData;
#endif

@end



