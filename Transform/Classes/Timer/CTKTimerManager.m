//
//  CTKTimerManager.m
//  Transform
//
//  Created by sun well on 2020/10/27.
//

#import "CTKTimerManager.h"

@implementation CTKTimerManager

- (void)fireTimer:(id)userInfo {
    if (self.weakTarget) {
        [self.weakTarget performSelector:self.weakSEL withObject:userInfo];
    } else {
        [self.weakTimer invalidate];
        self.weakTimer = nil;
    }
}
@end
