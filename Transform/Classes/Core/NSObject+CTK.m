//
//  NSObject+CTK.m
//  Transform
//
//  Created by sun well on 2020/10/22.
//

#import "NSObject+CTK.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"
#import "CTKCommonDefine.h"
#import "CTKUnrecognizedSelectorProtector.h"

const void * ctkprotectorkey = &ctkprotectorkey;

@implementation NSObject (CTK)
+ (void)load {
    [self swizzleInstanceMethodWithOriginalSel:@selector(forwardingTargetForSelector:) swizzledSel:@selector(ctk_forwardingTargetForSelector:)];
}

#pragma mark - Unrecognized Selector Protector
- (id)ctk_forwardingTargetForSelector:(SEL)aSelector {
    ctk_debug_log([NSString stringWithFormat:@"Runtime forwarding selector %@ to protector", NSStringFromSelector(aSelector)]);
    if ([self isMethodOverride:[self class] selector:aSelector] ||
        ![NSObject isMainBundleClass:[self class]]) {
        return [self ctk_forwardingTargetForSelector:aSelector];
    }
    
    class_addMethod(CTKUnrecognizedSelectorProtector.class, aSelector, (IMP)_ctkProtected, "@@:");
    self.ctkprotector = [CTKUnrecognizedSelectorProtector new];
    return self.ctkprotector;
}

#pragma mark - Getter & Setter
- (id)ctkprotector {
    return objc_getAssociatedObject(self, ctkprotectorkey);
}

- (void)setCtkprotector:(id)ctkprotector {
    objc_setAssociatedObject(self, ctkprotectorkey, ctkprotector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
