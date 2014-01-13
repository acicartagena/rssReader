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

-(void) fetchData:(void(^)(void))onSuccess{
    NSLog(@"fetch Data");

    NSURL *baseUrl = [NSURL URLWithString:@"http://feeds.bbci.co.uk"];
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
             onSuccess();
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
        media = [[attributeDict objectForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
        title = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"title:%@",title);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"description"]){
        description = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"description:%@",description);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"guid"]){
        link = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"link:%@",link);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"pubDate"]){
        pubDate = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"pubdate:%@",pubDate);
        currentElementValue = nil;
        
    }else if ([elementName isEqualToString:@"item"]){
        NSLog(@"title:%@",title);
        NSLog(@"description:%@",description);
        NSLog(@"link:%@",link);
        NSLog(@"pubDate:%@",pubDate);
        NSLog(@"media link:%@",media);
        if (media == nil){
            media = @" ";
        }
        temp = @{@"title":title, @"description":description, @"link":link,@"pubDate":pubDate,@"mediaLink":media};
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
