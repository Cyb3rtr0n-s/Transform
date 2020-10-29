//
//  CTKZombie.m
//  Transform
//
//  Created by sun well on 2020/10/28.
//

#import "CTKZombie.h"
#import <NSObject+Runtime.h>
#import <NSObject+CTK.h>
#import <CTKCommonDefine.h>

@implementation CTKZombie

- (id)forwardingTargetForSelector:(SEL)aSelector {
    ctk_debug_log([NSString stringWithFormat:@"This is a bad access crash for selector: %@", NSStringFromSelector(aSelector)]);
    Class tempProtector = [NSObject registerClassWithSel:aSelector];
    if (!self.ctkprotector) {
        self.ctkprotector = [tempProtector new];
    }
    
    return self.ctkprotector;
}

@end
