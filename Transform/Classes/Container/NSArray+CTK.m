//
//  NSArray+CTK.m
//  Transform
//
//  Created by sun well on 2020/10/23.
//

#import "NSArray+CTK.h"
#import <objc/runtime.h>
#import <NSObject+Runtime.h>
#import <CTKCommonDefine.h>

@implementation NSArray (CTK)
+ (void)load {
    Class emptyArray = objc_getClass("__NSArray0");
    Class singleArray = objc_getClass("__NSSingleObjectArrayI");
    Class normalArray = objc_getClass("__NSArrayI");
    [emptyArray swizzleInstanceMethodWithOriginalSel:@selector(objectAtIndex:) swizzledSel:@selector(ctk_empty_objectAtIndex:)];
    [singleArray swizzleInstanceMethodWithOriginalSel:@selector(objectAtIndex:) swizzledSel:@selector(ctk_single_objectAtIndex:)];
    [normalArray swizzleInstanceMethodWithOriginalSel:@selector(objectAtIndex:) swizzledSel:@selector(ctk_objectAtIndex:)];
}


- (id)ctk_empty_objectAtIndex:(NSUInteger)index {
    ctk_debug_log(@"Index out of bounds. Array is empty.");
    return nil;
}

- (id)ctk_single_objectAtIndex:(NSUInteger)index {
    if (index > 0) {
        ctk_debug_log(@"Index out of bounds.");
    }
    return [self ctk_single_objectAtIndex:0];
}

- (id)ctk_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self ctk_objectAtIndex:index];
    } else {
        ctk_debug_log(@"Index out of bounds.");
        return nil;
    }
}

@end
