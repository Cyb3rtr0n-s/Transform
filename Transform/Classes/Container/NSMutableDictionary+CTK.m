//
//  NSMutableDictionary+CTK.m
//  Transform
//
//  Created by sun well on 2020/10/24.
//

#import "NSMutableDictionary+CTK.h"
#import <objc/runtime.h>
#import <NSObject+Runtime.h>
#import <CTKCommonDefine.h>

@implementation NSMutableDictionary (CTK)

+ (void)load {
    Class muDictionary = objc_getClass("__NSDictionaryM");
    [muDictionary swizzleInstanceMethodWithOriginalSel:@selector(setValue:forKey:) swizzledSel:@selector(ctk_setValue:forKey:)];
    [muDictionary swizzleInstanceMethodWithOriginalSel:@selector(setObject:forKey:) swizzledSel:@selector(ctk_setObject:forKey:)];
}

- (void)ctk_setValue:(id)value
              forKey:(NSString *)key {
    if (value) {
        [self ctk_setValue:value forKey:key];
    } else {
        ctk_debug_log(@"Can't insert nil into a dictionary. Use NSNull instead.");
    }
}

- (void)ctk_setObject:(id)anObject
               forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self ctk_setObject:anObject forKey:aKey];
    } else {
        ctk_debug_log(@"Can't insert nil object or nil key into a dictionary.");
    }
}
@end
