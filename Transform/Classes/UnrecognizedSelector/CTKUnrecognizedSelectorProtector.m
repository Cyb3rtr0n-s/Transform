//
//  CTKUnrecognizedSelectorProtector.m
//  Transform
//
//  Created by sun well on 2020/10/22.
//

#import "CTKUnrecognizedSelectorProtector.h"
#import "CTKCommonDefine.h"
#import "CTKCommonLiteral.h"

@implementation CTKUnrecognizedSelectorProtector

- (id)_ctkProtected(id self, SEL sel) {
    ctk_debug_log([NSString stringWithFormat:@"Selector %@ is protected.", NSStringFromSelector(sel)]);
    return nil;
}

@end
