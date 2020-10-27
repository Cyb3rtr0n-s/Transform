//
//  NSMutableArray+CTK.m
//  Transform
//
//  Created by sun well on 2020/10/24.
//

#import "NSMutableArray+CTK.h"
#import <objc/runtime.h>
#import <NSObject+Runtime.h>
#import <CTKCommonDefine.h>

@implementation NSMutableArray (CTK)

+ (void)load {
    Class muArray = objc_getClass("__NSArrayM");
    [muArray swizzleInstanceMethodWithOriginalSel:@selector(addObject:) swizzledSel:@selector(ctk_addObject:)];
    [muArray swizzleInstanceMethodWithOriginalSel:@selector(objectAtIndex:) swizzledSel:@selector(ctk_objectAtIndex:)];
}

- (void)ctk_addObject:(id)anObject {
    if (anObject) {
        [self ctk_addObject:anObject];
    } else {
        ctk_debug_log(@"Can't add nil to array.");
    }
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
