//
//  NSObject+CTKZombie.m
//  Transform
//
//  Created by sun well on 2020/10/28.
//

#import "NSObject+CTKZombie.h"
#import <objc/runtime.h>
#import <NSObject+Runtime.h>
#import <CTKCommonDefine.h>
#import "CTKZombie.h"

static const void * CTK_AssociationKey_NeedZombieProtector = &CTK_AssociationKey_NeedZombieProtector;
static const void * CTK_AssociationKey_OriginalClassName = &CTK_AssociationKey_OriginalClassName;

static char * const ctkZombieQueueName = "com.transform.zombie_operation_queue";
static dispatch_queue_t ctkZombieQueue;
static NSInteger const kMaxZombieCacheCount = 4;
static NSInteger const kFreeZombieCountPerTime = 2;
static NSMutableArray *cachedZombies;
static NSArray<NSString *> *whiteListZombies;
static NSArray<NSString *> *blackListZombies;

static void freeZombies(int count) {
    
}

@implementation NSObject (CTKZombie)

+ (void)load {
    [self swizzleClassMethodWithOriginalSel:@selector(allocWithZone:) swizzledSel:@selector(ctk_allocWithZone:)];
    
    whiteListZombies = @[@"NSBundle"];
    cachedZombies = [NSMutableArray array];
    ctkZombieQueue = dispatch_queue_create(ctkZombieQueueName, DISPATCH_QUEUE_SERIAL);
}


+ (instancetype)ctk_allocWithZone:(struct _NSZone *)zone {
    NSObject *obj = [self ctk_allocWithZone:zone];
    NSString *class = NSStringFromClass(obj.class);
    if ([blackListZombies containsObject:class] &&
        ![whiteListZombies containsObject:class]) {
        obj.needZombieProtector = YES;
    }
    return obj;
}

- (void)ctk_zombieDealloc {
    NSObject *castObj = self;
    castObj.originalClassName = NSStringFromClass(self.class);
    
    objc_destructInstance(self);
#warning Error with objc_setClass
//    objc_setClass(self, [CTKZombie class]);
    
    dispatch_async(ctkZombieQueue, ^{
        // Zombies limit in memory.
        NSUInteger count = cachedZombies.count;
        if (count > kMaxZombieCacheCount) {
            freeZombies(MIN((int)count, (int)kFreeZombieCountPerTime));
        }
        
        NSValue *value = [NSValue valueWithNonretainedObject:self];
        [cachedZombies addObject:value];
    });
}

#pragma mark - Getter & Setter
- (void)setOriginalClassName:(NSString *)originalClassName {
    objc_setAssociatedObject(self, CTK_AssociationKey_OriginalClassName, originalClassName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)originalClassName {
    return objc_getAssociatedObject(self, CTK_AssociationKey_OriginalClassName);
}

- (void)setNeedZombieProtector:(BOOL)needZombieProtector {
    objc_setAssociatedObject(self, CTK_AssociationKey_NeedZombieProtector, @(needZombieProtector), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)needZombieProtector {
    return [objc_getAssociatedObject(self, CTK_AssociationKey_NeedZombieProtector) boolValue];
}
@end
