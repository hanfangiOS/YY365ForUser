//
//  SNXMLRequestOperation.m
//  Weibo
//
//  Created by Wade Cheng on 3/23/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "SNXMLRequestOperation.h"
#include <Availability.h>
#import "TBXML.h"
#import "SNNetworkClient+XML.h"

static dispatch_queue_t sn_xml_request_operation_processing_queue;
static dispatch_queue_t xml_request_operation_processing_queue() {
    if (sn_xml_request_operation_processing_queue == NULL) {
        sn_xml_request_operation_processing_queue = dispatch_queue_create("com.sina.networking.xml-request.processing", 0);
    }
    
    return sn_xml_request_operation_processing_queue;
}

static void _replace(NSMutableString *string, NSString *srcSubstring, NSString *destSubString)
{
    [string replaceOccurrencesOfString:srcSubstring
                            withString:destSubString
                               options:0
                                 range:NSMakeRange(0, [string length])];
}

static NSString *decode(NSString *s)
{
    if (!s) return nil;
    NSMutableString *string = [NSMutableString stringWithString:s];
    
    void (^replace)(NSString *srcSubstring, NSString *destSubString) = ^(NSString *srcSubstring, NSString *destSubString) {
        [string replaceOccurrencesOfString:srcSubstring
                                withString:destSubString
                                   options:0
                                     range:NSMakeRange(0, [string length])];
    };
    
    replace(@"&lt;", @"<");
    replace(@"&gt;", @">");
    replace(@"&quot;", @"\"");
    replace(@"&shy;", @"");
    replace(@"&bull;", @".");
    replace(@"&apos;", @"'");
    replace(@"&thorn;", @"þ");
    replace(@"&yuml;", @"ÿ");
    replace(@"&yacute;", @"ý");
    replace(@"&uuml;", @"ü");
    replace(@"&ucirc;", @"ü");
    replace(@"&uacute;", @"ú");
    replace(@"&ugrave;", @"ù");
    replace(@"&oslash;", @"ø");
    replace(@"&divide;", @"÷");
    replace(@"&ouml;", @"ö");
    
    replace(@"&otilde;", @"õ");
    replace(@"&ocirc;", @"ô");
    replace(@"&oacute;", @"ó");
    replace(@"&ograve;", @"ò");
    replace(@"&ntilde;", @"ñ");	
    replace(@"&eth;", @"ð");
    replace(@"&iuml;", @"ï");
    replace(@"&icirc;", @"î");
    replace(@"&iacute;", @"í");
    replace(@"&igrave;", @"ì");	
    
    replace(@"&euml;", @"ë");
    replace(@"&ecirc;", @"ê");
    replace(@"&eacute;", @"é");
    replace(@"&egrave;", @"è");
    replace(@"&ccedil;", @"ç");
    replace(@"&aelig;", @"æ");	
    replace(@"&aring;", @"å");	
    replace(@"&auml;", @"ä");	
    
    replace(@"&atilde;", @"ã");	
    replace(@"&acirc;", @"â");	
    replace(@"&aacute;", @"á");	
    replace(@"&agrave;", @"à");	
    
    
    replace(@"&szlig;", @"ß");	
    replace(@"&THORN;", @"Þ");	
    replace(@"&Yacute;", @"Ý");	
    replace(@"&Uuml;", @"Ü");
    replace(@"&Ucirc;", @"Û");
    replace(@"&Uacute;", @"Ú");
    replace(@"&Ugrave;", @"Ù");
    replace(@"&Oslash;", @"Ø");	
    
    replace(@"&times;", @"×");	
    replace(@"&Ouml;", @"Ö");	
    replace(@"&Otilde;", @"Õ");	
    replace(@"&Ocirc;", @"Ô");
    replace(@"&Oacute;", @"Ó");
    replace(@"&Ograve;", @"Ò");
    replace(@"&Ntilde;", @"Ñ");
    replace(@"&ETH;", @"Ð");	
    
    
    replace(@"&Imul;", @"Ï");
    replace(@"&Icirc;", @"Î");
    replace(@"&Iacute;", @"Í");	
    replace(@"&Igrave;", @"Ì");	
    
    replace(@"&Euml;", @"Ë");
    replace(@"&Ecirc;", @"Ê");
    replace(@"&Eacute;", @"É");	
    replace(@"&Egrave;", @"È");	
    
    replace(@"&Ccedil;", @"Ç");
    replace(@"&AElig;", @"Æ");
    replace(@"&Aring;", @"Å");	
    replace(@"&Auml;", @"Ä");	
    replace(@"&Atilde;", @"Ã");	
    replace(@"&Acirc;", @"Â");	
    replace(@"&Aacute;", @"Á");	
    replace(@"&Agrave;", @"À");
    replace(@"&iquest;", @"À");	
    
    replace(@"&frac34;", @"¾");	
    replace(@"&frac12;", @"½");	
    replace(@"&frac14;", @"¼");	
    replace(@"&raquo;", @"»");	
    replace(@"&ordm;", @"º");	
    
    replace(@"&supl;", @"¹");	
    replace(@"&cedil;", @"¸");	
    replace(@"&middot;", @"·");	
    replace(@"&para;", @"¶");	
    replace(@"&micro;", @"·");	
    replace(@"&para;", @"µ");	
    
    replace(@"&acute;", @"´");	
    replace(@"&sup3;", @"³");	
    replace(@"&plusmn;", @"±");	
    replace(@"&sup2;", @"²");	
    replace(@"&deg;", @"°");	
    replace(@"&macr;", @"¯");	
    replace(@"&reg;", @"®");	
    replace(@"&sny;", @"");	
    
    replace(@"&not;", @"«");	
    replace(@"&ordf;", @"ª");
    replace(@"&copy;", @"©");	
    replace(@"&uml;", @"¨");
    replace(@"&sect;", @"§");	
    replace(@"&brvbar;", @"¦");
    replace(@"&yen;", @"¥");	
    replace(@"&curren;", @"¤");
    
    replace(@"&pound;", @"£");	
    replace(@"&cent;", @"¢");
    replace(@"&iexcl;", @"¡");	
    replace(@"&nbsp;", @" ");
    //	replace(@"&gt;", @">");	
    //	replace(@"&lt;", @"<");
    //	replace(@"&amp;", @"&");	
    replace(@"&quot;", @"\"");
    replace(@"&amp;", @"&");	//必须再最后
    
    return string;
}

@interface SNXMLRequestOperation ()

@property (readwrite, nonatomic, retain) id responseXML;
@property (readwrite, nonatomic, retain) NSError *XMLError;

+ (NSSet *)defaultAcceptableContentTypes;
+ (NSSet *)defaultAcceptablePathExtensions;

@end

@implementation SNXMLRequestOperation

@synthesize responseXML = _responseXML;
@synthesize XMLError = _XMLError;

- (void)configWithSettings:(NSDictionary *)settings
{
    [_arrayQueryPaths release];
    _arrayQueryPaths = [[settings objectForKey:kSNXMLResponseArrayQueryPathsKey] retain];
}

+ (NSSet *)defaultAcceptableContentTypes
{
    return [NSSet setWithObjects:@"application/xml", @"text/xml", nil];
}

+ (NSSet *)defaultAcceptablePathExtensions
{
    return [NSSet setWithObjects:@"xml", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request
{
//    NSString *requestTag = [request valueForHTTPHeaderField:kSNNetworkRequestHeaderTagName];
//    BOOL isNormalRequest = [requestTag isEqualToString:kSNNetworkRequestHeaderTagValueNormal] || [requestTag isEqualToString:kSNNetworkRequestHeaderTagValueUpload];
    
    return /*isNormalRequest && */([[self defaultAcceptableContentTypes] containsObject:[request valueForHTTPHeaderField:@"Accept"]] || [[self defaultAcceptablePathExtensions] containsObject:[[request URL] pathExtension]]);
}

- (void)dealloc
{
    [_XMLError release];
    [_responseXML release];
    [_arrayQueryPaths release];
    
    [super dealloc];
}

//- (id)parseXMLWithElement:(TBXMLElement *)element path:(NSString *)elePath
//{
//    if (!element)
//    {
//        return nil;
//    }
//    
//    if (element->firstChild)
//    {
//        NSMutableDictionary *childContext = [NSMutableDictionary dictionary];
//        TBXMLElement *childEle = element->firstChild;
//        do {
//            
//            NSString *childEleName = [TBXML elementName:childEle];
//            NSString *childElePath = elePath ? [NSString stringWithFormat:@"%@.%@", elePath, childEleName] : childEleName;
//            
//            id childEleParsedValue =  [self parseXMLWithElement:childEle path:childElePath];
//            if (!childEleParsedValue) continue;
//            
//            id storedValue = [childContext objectForKey:childEleName];
//            
//            // 原来已经存储过相同节点名称的数据
//            if (storedValue)
//            {
//                // 原来存的就是array
//                if ([storedValue isKindOfClass:[NSMutableArray class]])
//                {
//                    [storedValue addObject:childEleParsedValue];
//                }
//                // 原来存的是普通数据
//                else
//                {
//                    storedValue = [NSMutableArray arrayWithObjects:storedValue, childEleParsedValue, nil];
//                    [childContext setObject:storedValue forKey:childEleName];
//                }
//            }
//            // 首次发现一个需要以array形式存储的节点
//            else if ([_arrayQueryPaths containsObject:childElePath])
//            {
//                storedValue = [NSMutableArray arrayWithObject:childEleParsedValue];
//                [childContext setObject:storedValue forKey:childEleName];
//            }
//            // 首次发现普通节点
//            else
//            {
//                [childContext setObject:childEleParsedValue forKey:childEleName];
//            }
//            
//        } while ((childEle = childEle->nextSibling));
//        
//        return childContext;
//    }
//    
//    NSString *eleText = [TBXML textForElement:element];
//    if ([eleText isEqualToString:@""])
//    {
//        return nil;
//    }
//    return decode(eleText);
//}

// TODO ：修改path参数
- (id)parseXMLWithElement:(TBXMLElement *)element path:(NSString *)path
{
    NSMutableDictionary *elementDict = [[NSMutableDictionary alloc] init];
    
    TBXMLAttribute *attribute = element->firstAttribute;
    while (attribute)
    {
        [elementDict setValue:[TBXML attributeValue:attribute] forKey:[TBXML attributeName:attribute]];
        attribute = attribute->next;
    }
    
    TBXMLElement *childElement = element->firstChild;
    if (childElement) {
        
        while (childElement) {
            
            if ([elementDict objectForKey:[TBXML elementName:childElement]] == nil) {
                
                [elementDict addEntriesFromDictionary:[self parseXMLWithElement:childElement path:nil]];
                
            } else if ([[elementDict objectForKey:[TBXML elementName:childElement]] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[elementDict objectForKey:[TBXML elementName:childElement]]];
                [items addObject:[[self parseXMLWithElement:childElement path:nil] objectForKey:[TBXML elementName:childElement]]];
                [elementDict setValue:[NSArray arrayWithArray:items] forKey:[TBXML elementName:childElement]];
                [items release]; items = nil;
                
            } else {
                
                NSMutableArray *items = [[NSMutableArray alloc] init];
                [items addObject:[elementDict objectForKey:[TBXML elementName:childElement]]];
                [items addObject:[[self parseXMLWithElement:childElement path:nil] objectForKey:[TBXML elementName:childElement]]];
                [elementDict setValue:[NSArray arrayWithArray:items] forKey:[TBXML elementName:childElement]];
                [items release]; items = nil;
            }
            
            childElement = childElement->nextSibling;
        }
        
    } else if ([TBXML textForElement:element] != nil && [TBXML textForElement:element].length>0) {
        
        [elementDict setValue:[TBXML textForElement:element] forKey:[TBXML elementName:element]];
    }
    
    
    NSDictionary *resultDict = nil;
    
    if ([elementDict count]>0) {
        
        if ([elementDict valueForKey:[TBXML elementName:element]] == nil) {
            resultDict = [NSDictionary dictionaryWithObject:elementDict forKey:[TBXML elementName:element]];
        } else {
            resultDict = [NSDictionary dictionaryWithDictionary:elementDict];
        }
    }
    
    [elementDict release]; elementDict = nil;
    
    return resultDict;
}

- (BOOL)validateXMLStructureBeforeParse:(TBXML *)tbxml
{
    return YES;
}

- (BOOL)validateXMLStructureAfterParse:(TBXML *)tbxml
{
    return YES;
}

- (id)responseXML
{
    if (!_responseXML && [self.responseData length] > 0 && [self isFinished])
    {
        @autoreleasepool {
            TBXML *tbxml = [[TBXML alloc] initWithXMLData:self.responseData error:&_XMLError];
            
            if (!_XMLError && [self validateXMLStructureBeforeParse:tbxml])
            {
                // 如果只有根节点，没有子节点
                if (tbxml.rootXMLElement && !tbxml.rootXMLElement->firstChild)
                {
                    self.responseXML = [NSDictionary dictionaryWithObject:[TBXML textForElement:tbxml.rootXMLElement]
                                                                   forKey:[TBXML elementName:tbxml.rootXMLElement]];
                }
                else
                {
                    self.responseXML = [self parseXMLWithElement:tbxml.rootXMLElement path:nil];
                }
                
                [self validateXMLStructureAfterParse:tbxml];
            }
            
            
            [tbxml release];
        }
    }
    
    return _responseXML;
}

- (NSError *)error
{
    if (_XMLError)
    {
        return _XMLError;
    }
    else
    {
        return [super error];
    }
}

#pragma mark - NSOperation

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    self.completionBlock = ^ {
        if ([self isCancelled])
        {
            return;
        }
        
        if (self.error)
        {
            if (failure)
            {
                dispatch_async(self.failureCallbackQueue ? self.failureCallbackQueue : dispatch_get_main_queue(), ^{
                    failure(self, self.error);
                });
            }
        }
        else
        {
            dispatch_async(xml_request_operation_processing_queue(), ^(void) {
                id XML = self.responseXML;
                
                if (self.XMLError)
                {
                    if (failure)
                    {
                        dispatch_async(self.failureCallbackQueue ? self.failureCallbackQueue : dispatch_get_main_queue(), ^{
                            failure(self, self.XMLError);
                        });
                    }
                }
                else
                {
                    if (success)
                    {
                        dispatch_async(self.successCallbackQueue ? self.successCallbackQueue : dispatch_get_main_queue(), ^{
                            success(self, XML);
                        });
                    } 
                }
            });
        }
    };    
}

@end