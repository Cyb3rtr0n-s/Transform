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

const void * CTK_AssociationKey_Protector = &CTK_AssociationKey_Protector;
const void * CTK_AssociationKey_KVO = &CTK_AssociationKey_KVO;

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

#pragma mark - KVO Protector
- (void)ctk_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context {
    
}

- (void)ctk_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath {
    
}

#pragma mark - Getter & Setter
- (id)ctkprotector {
    return objc_getAssociatedObject(self, CTK_AssociationKey_Protector);
}

- (void)setCtkprotector:(id)ctkprotector {
    objc_setAssociatedObject(self, CTK_AssociationKey_Protector, ctkprotector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CTKKVODelegate *)kvoDelegate {
    return objc_getAssociatedObject(self, CTK_AssociationKey_KVO);
}

- (void)setKvoDelegate:(CTKKVODelegate * _Nonnull)kvoDelegate {
    objc_setAssociatedObject(self, CTK_AssociationKey_KVO, kvoDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
