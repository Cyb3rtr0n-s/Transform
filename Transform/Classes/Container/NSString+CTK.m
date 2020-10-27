//
//  NSString+CTK.m
//  Transform
//
//  Created by sun well on 2020/10/24.
//

#import "NSString+CTK.h"
#import <NSObject+Runtime.h>
#import <CTKCommonDefine.h>

@implementation NSString (CTK)
+ (void)load {
    [self swizzleInstanceMethodWithOriginalSel:@selector(substringFromIndex:) swizzledSel:@selector(ctk_substringFromIndex:)];
    [self swizzleInstanceMethodWithOriginalSel:@selector(substringToIndex:) swizzledSel:@selector(ctk_substringToIndex:)];
    [self swizzleInstanceMethodWithOriginalSel:@selector(substringWithRange:) swizzledSel:@selector(ctk_substringWithRange:)];
    [self swizzleInstanceMethodWithOriginalSel:@selector(containsString:) swizzledSel:@selector(ctk_containsString:)];
}

- (NSString *)ctk_substringFromIndex:(NSUInteger)from {
    if (from <= self.length) {
        return [self ctk_substringFromIndex:from];
    } else {
        ctk_debug_log(@"Index out of range.");
        return nil;
    }
}

- (NSString *)ctk_substringToIndex:(NSUInteger)to {
    if (to <= self.length) {
        return [self ctk_substringToIndex:to];
    } else {
        ctk_debug_log(@"Index out of range.");
        return nil;
    }
}

- (NSString *)ctk_substringWithRange:(NSRange)range {
    if (range.location - 1 <= self.length &&
        range.location + range.length - 1 <= self.length) {
        return [self ctk_substringWithRange:range];
    } else {
        ctk_debug_log(@"Range out of range.");
        return nil;
    }
}

- (BOOL)ctk_containsString:(NSString *)string {
    if (string.length == 0) {
        return NO;
    }
    
    NSRange range = [self rangeOfString:string];
    return range.length != 0;
}
@end
