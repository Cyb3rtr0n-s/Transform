//
//  NSDictionary+CTK.m
//  Transform
//
//  Created by sun well on 2020/10/24.
//

#import "NSDictionary+CTK.h"
#import <objc/runtime.h>
#import <NSObject+Runtime.h>
#import <CTKCommonDefine.h>

@implementation NSDictionary (CTK)
+ (void)load {
    Class dictionary = objc_getClass("__NSPlaceholderDictionary");
    [dictionary swizzleInstanceMethodWithOriginalSel:@selector(initWithObjects:forKeys:count:) swizzledSel:@selector(ctk_initWithObjects:forKeys:count:)];
}

- (instancetype)ctk_initWithObjects:(id _Nonnull const [])objects
                            forKeys:(id<NSCopying> _Nonnull const [])keys
                              count:(NSUInteger)count {
    id newObjects[count];
    id<NSCopying> newKeys[count];
    NSUInteger index = 0;
    
    for (int i = 0; i < count; i ++) {
        if (!objects[i] || !keys[i]) {
            ctk_debug_log(@"Can't init a dictionary with a nil object or a nil key.");
            continue;
        }
        newObjects[index] = objects[i];
        newKeys[index] = keys[i];
        index ++;
    }
    return [self ctk_initWithObjects:newObjects forKeys:newKeys count:index];
}
@end
