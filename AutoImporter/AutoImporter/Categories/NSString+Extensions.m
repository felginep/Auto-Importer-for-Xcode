//
//  NSString+Extensions.m
//  PropertyParser
//
//  Created by marko.hlebar on 7/20/13.
//  Copyright (c) 2013 Clover Studio. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)
- (BOOL)mh_containsString:(NSString *)string {
	return [self rangeOfString:string].location != NSNotFound;
}

- (NSString *)mh_stringByRemovingWhitespacesAndNewlines {
	NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
	return [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (BOOL)mh_isAlphaNumeric {
	NSCharacterSet *unwantedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	return [self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound;
}

- (BOOL)mh_isWhitespaceOrNewline {
	NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
	string = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	return string.length == 0;
}

NSString * const LAFAddImportOperationImportRegexPattern = @"^#.*(import|include).*[\",<].*[\",>]";

- (NSRegularExpression *)importRegex {
    static NSRegularExpression *_regex = nil;
    if (!_regex) {
        NSError *error = nil;
        _regex = [[NSRegularExpression alloc] initWithPattern:LAFAddImportOperationImportRegexPattern
                                                      options:0
                                                        error:&error];
    }
    return _regex;
}

- (BOOL)ad_isImport {
    NSRegularExpression * regex = [self importRegex];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return numberOfMatches > 0;
}

- (BOOL)ad_isExternalImport {
    return [self ad_isImport] && [self containsString:@"<"] && [self containsString:@">"];
}

- (BOOL)ad_isCategoryImport {
    return [self ad_isImport] && [self containsString:@"+"] && ![self ad_isExternalImport];
}

@end
