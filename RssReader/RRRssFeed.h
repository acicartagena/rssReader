//
//  RRRssFeed.h
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRRssEntryCell.h"

@interface RRRssFeed : NSObject<NSXMLParserDelegate>{
    NSString *title;
    NSString *description;
    NSString *link;
    NSString *pubDate;
    NSString *media;
    NSDictionary *temp;
    NSMutableString *currentElementValue;
    bool skipElement;
    
}

@property (nonatomic,strong) NSMutableArray *elementsArray;

-(void) fetchData:(void(^)(void))onSuccess;

@end
