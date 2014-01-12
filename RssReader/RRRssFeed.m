//
//  RRRssFeed.m
//  RssReader
//
//  Created by Aci Cartagena on 1/10/14.
//  Copyright (c) 2014 Aci Cartagena. All rights reserved.
//

#import "RRRssFeed.h"
#import "AFNetworking.h"


@implementation RRRssFeed

-(id) init{
    self = [super init];
    if (self){
        self.elementsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) fetchData{
    NSLog(@"fetch Data");
    //NSURL *url = [NSURL URLWithString:@"http://feeds.bbci.co.uk/news/rss.xml?edition=int#"];
    NSURL *baseUrl = [NSURL URLWithString:@"http://feeds.bbci.co.uk"];
    ///news?pz=1&cf=all&ned=en_ph&hl=en&output=rss
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //AFXMLParserResponseSerializer
    NSDictionary *parms = [[NSDictionary alloc] initWithObjectsAndKeys:@"int",@"edition", nil];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
    [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"application/rss+xml"]];
    NSLog(@"afhttp response serializer:%@",[manager responseSerializer]);
    [manager GET:@"/news/rss.xml"
      parameters:parms
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //
          NSLog(@"response:%@",responseObject);
             NSXMLParser *parser = (NSXMLParser *)responseObject;
             [parser setDelegate:self];
             [parser parse];
      }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          //
          NSLog(@"error:%@",error);
      }];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
//    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //code
//        NSLog(@"response: %@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //<#code#>
//        NSLog(@"error: %@",error);
//    }];
//    [operation start];
}

#pragma mark NSXMLParser Delegate Methods
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //NSLog(@"element name:%@",elementName);
    //if ([elementName isEqualToString:@"item"]){
    //    temp = [[NSMutableDictionary alloc] init];
    //}
    
    if ([elementName isEqualToString:@"media:thumbnail"]){
        media = [attributeDict objectForKey:@"url"];
    }
    
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if (!currentElementValue){
        currentElementValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentElementValue appendString:string];
    
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if ([elementName isEqualToString:@"title"]){
        title = currentElementValue;
        //NSLog(@"title:%@",title);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"description"]){
        description = currentElementValue;
        //NSLog(@"description:%@",description);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"guid"]){
        link = currentElementValue;
        //NSLog(@"link:%@",link);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"pubDate"]){
        pubDate = currentElementValue;
        //NSLog(@"pubdate:%@",pubDate);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"item"]){
        temp = [[NSDictionary alloc] initWithObjectsAndKeys:@"title",title,@"description",description,@"link",link,@"pubDate",pubDate,@"mediaLink",media, nil];
        //NSLog(@"media:%@",media);
        NSLog(@"item ! temp:%@",temp);
        [self.elementsArray addObject:temp];
        
        temp = nil;
        title = nil;
        description = nil;
        link = nil;
        pubDate = nil;
        media = nil;
        currentElementValue = nil;
        
    }
}



@end
