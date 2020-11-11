//
//  NSObject+Runtime.m
//  Transform
//
//  Created by sun well on 2020/10/22.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>
#import "CTKCommonLiteral.h"
#import "CTKCommonDefine.h"

id _ctkProtected(id self, SEL sel) {
    ctk_debug_log([NSString stringWithFormat:@"Selector %@ is protected.", NSStringFromSelector(sel)]);
    return nil;
}

@implementation NSObject (Runtime)

+ (void)swizzleClassMethodWithOriginalSel:(SEL)oriSel
                              swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    Method oriMethod = class_getClassMethod(cls, oriSel);
    Method swiMethod = class_getClassMethod(cls, swiSel);
    [self _ctkSwizzleWithOriginalMethod:oriMethod swizzledMethod:swiMethod class:cls];
}

+ (void)swizzleInstanceMethodWithOriginalSel:(SEL)oriSel
                                 swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    Method oriMethod = class_getInstanceMethod(cls, oriSel);
    Method swiMethod = class_getInstanceMethod(cls, swiSel);
    [self _ctkSwizzleWithOriginalMethod:oriMethod swizzledMethod:swiMethod class:cls];
}

- (BOOL)isMethodOverride:(Class)cls
                selector:(SEL)aSelector {
    IMP imp = class_getMethodImplementation(cls, aSelector);
    IMP superIMP = class_getMethodImplementation([cls superclass], aSelector);
    return imp != superIMP;
}

+ (BOOL)isCustomClass:(Class)cls {
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    NSString *customClassBundlePath = [NSBundle bundleForClass:cls].bundlePath;
    return cls && mainBundlePath && customClassBundlePath && [customClassBundlePath hasPrefix:mainBundlePath];
}

+ (BOOL)isMainBundleClass:(Class)cls {
    return cls && [[NSBundle bundleForClass:cls] isEqual:[NSBundle mainBundle]];
}

+ (Class)registerClassWithSel:(SEL)aSelector {
    Class protector = objc_getClass(CTK_Protector_Temp_Class);
    if (!protector) {
        protector = objc_allocateClassPair([NSObject class], CTK_Protector_Temp_Class, sizeof([NSObject class]));
        objc_registerClassPair(protector);
    }
    class_addMethod(protector, aSelector, (IMP)_ctkProtected, "@@:");
    return protector;
}

#pragma mark - Helper
+ (void)_ctkSwizzleWithOriginalMethod:(Method)oriMethod
                       swizzledMethod:(Method)swiMethod
                                class:(Class)class {
//    BOOL didAddMethod = class_addMethod(class, method_getName(oriMethod), method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class, method_getName(swiMethod), method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
//    } else {
//        method_exchangeImplementations(oriMethod, swiMethod);
//    }
    method_exchangeImplementations(oriMethod, swiMethod);
}

@end
