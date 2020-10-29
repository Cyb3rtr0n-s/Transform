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
#import "CTKKVODelegate.h"

const void * CTK_AssociationKey_Protector = &CTK_AssociationKey_Protector;
const void * CTK_AssociationKey_KVO = &CTK_AssociationKey_KVO;

@implementation NSObject (CTK)
+ (void)load {
    [self swizzleInstanceMethodWithOriginalSel:@selector(forwardingTargetForSelector:) swizzledSel:@selector(ctk_forwardingTargetForSelector:)];
    [self swizzleInstanceMethodWithOriginalSel:@selector(addObserver:forKeyPath:options:context:) swizzledSel:@selector(ctk_addObserver:forKeyPath:options:context:)];
    [self swizzleInstanceMethodWithOriginalSel:@selector(removeObserver:forKeyPath:) swizzledSel:@selector(ctk_removeObserver:forKeyPath:)];
}

#pragma mark - Unrecognized Selector Protector
- (id)ctk_forwardingTargetForSelector:(SEL)aSelector {
    ctk_debug_log([NSString stringWithFormat:@"Runtime forwarding selector %@ to protector", NSStringFromSelector(aSelector)]);
    if ([self isMethodOverride:[self class] selector:aSelector] ||
        ![NSObject isMainBundleClass:[self class]]) {
        return [self ctk_forwardingTargetForSelector:aSelector];
    }
    
    Class tempProtector = [NSObject registerClassWithSel:aSelector];
    self.ctkprotector = [tempProtector new];
    return self.ctkprotector;
}

#pragma mark - KVO Protector
- (void)ctk_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context {
    ctk_debug_log([NSString stringWithFormat:@"⚠️KVO observer class is %@", NSStringFromClass(self.class)]);
    
    if ([observer isKindOfClass:CTKKVODelegate.class]) {
        return [self ctk_addObserver:observer
                          forKeyPath:keyPath
                             options:options
                             context:context];
    }
    
    if (!observer || keyPath.length == 0) {
        ctk_debug_log(@"🙅‍♂️Add observer error, please check observer or keypath.");
        return;
    }
    
    if (!self.kvoDelegate) {
        self.kvoDelegate = [CTKKVODelegate new];
        self.kvoDelegate.weakObservedObject = self;
    }
    
    NSMutableDictionary *kvoObMaps = self.kvoDelegate.kvoObserverMaps;
    NSMutableArray *obArray = [NSMutableArray arrayWithArray:kvoObMaps[keyPath]];
    CTKKVOObserver *ob = [CTKKVOObserver new];
    ob.observer = observer;
    
    if (obArray.count > 0) {
        BOOL didAdded = NO;
        for (CTKKVOObserver *ob in obArray) {
            if (ob.observer == observer) {
                didAdded = YES;
                break;
            }
        }
        
        if (didAdded) {
            ctk_debug_log([NSString stringWithFormat:@"⚠️This observer has added:%@", NSStringFromClass(self.class)]);
            return;
        } else {
            [obArray addObject:ob];
            kvoObMaps[keyPath] = obArray;
            return [self ctk_addObserver:self.kvoDelegate
                              forKeyPath:keyPath
                                 options:options
                                 context:context];
        }
    } else {
        [obArray addObject:ob];
        kvoObMaps[keyPath] = obArray;
        return [self ctk_addObserver:self.kvoDelegate
                          forKeyPath:keyPath
                             options:options
                             context:context];
    }
}

- (void)ctk_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath {
    if ([observer isKindOfClass:CTKKVODelegate.class]) {
        return [self ctk_removeObserver:observer forKeyPath:keyPath];
    }
    
    if (!observer || keyPath.length == 0) {
        ctk_debug_log(@"🙅‍♂️Remove observer error, please check observer or keypath.");
        return;
    }
    
    NSMutableDictionary *kvoObMaps = self.kvoDelegate.kvoObserverMaps;
    NSMutableArray *obArray = [NSMutableArray array];
    if ([kvoObMaps.allKeys containsObject:keyPath]) {
        [obArray addObjectsFromArray:kvoObMaps[keyPath]];
    }
    
    if (obArray.count > 0) {
        NSMutableArray *waitToRemove = [NSMutableArray array];
        for (CTKKVOObserver *ob in obArray) {
            if (ob.observer == observer) {
                [waitToRemove addObject:ob];
            }
        }
        
        [obArray removeObjectsInArray:waitToRemove];
        if (obArray.count == 0) {
            [kvoObMaps removeObjectForKey:keyPath];
            return [self ctk_removeObserver:self.kvoDelegate
                                 forKeyPath:keyPath];
        }
    } else {
        ctk_debug_log(@"⚠️Observer has been removed.");
        [kvoObMaps removeObjectForKey:keyPath];
        return;
    }
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
