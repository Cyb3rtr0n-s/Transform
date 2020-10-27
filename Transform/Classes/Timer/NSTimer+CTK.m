//
//  NSTimer+CTK.m
//  Transform
//
//  Created by sun well on 2020/10/27.
//

#import "NSTimer+CTK.h"
#import <NSObject+Runtime.h>
#import "CTKTimerManager.h"

@implementation NSTimer (CTK)

+ (void)load {
    [NSTimer swizzleClassMethodWithOriginalSel:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSel:@selector(ctk_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
}

+ (NSTimer *)ctk_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         target:(id)aTarget
                                       selector:(SEL)aSelector
                                       userInfo:(nullable id)userInfo
                                        repeats:(BOOL)yesOrNo {
    if (yesOrNo) {
        CTKTimerManager *manager = [[CTKTimerManager alloc] init];
        manager.weakTarget = aTarget;
        manager.weakSEL = aSelector;
        manager.weakTimer = [self ctk_scheduledTimerWithTimeInterval:ti
                                                              target:aTarget
                                                            selector:aSelector
                                                            userInfo:userInfo
                                                             repeats:yesOrNo];
        return manager.weakTimer;
    } else {
        return [self ctk_scheduledTimerWithTimeInterval:ti
                                                 target:aTarget
                                               selector:aSelector
                                               userInfo:userInfo
                                                repeats:yesOrNo];
    }
}

+ (id)ctk_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                   block:(void (^)(NSTimer *timer))block
                                 repeats:(BOOL)repeats {
    NSParameterAssert(block);
    return [self scheduledTimerWithTimeInterval:timeInterval
                                         target:self
                                       selector:@selector(ctk_executeBlockFromTimer:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (id)ctk_timerWithTimeInterval:(NSTimeInterval)timeInterval
                          block:(void (^)(NSTimer *timer))block
                        repeats:(BOOL)repeats {
    NSParameterAssert(block);
    return [self timerWithTimeInterval:timeInterval
                                target:self
                              selector:@selector(ctk_executeBlockFromTimer:)
                              userInfo:[blovk copy]
                               repeats:repeats];
}


+ (void)ctk_executeBlockFromTimer:(NSTimer *)aTimer {
    void (^block)(NSTimer *timer) = [aTimer userInfo];
    if (block) {
        block(aTimer);
    }
}

@end
