//
//  CTKUnrecognizedSelectorProtector.h
//  Transform
//
//  Created by sun well on 2020/10/22.
//

#import <Foundation/Foundation.h>
#import <CTKCommonDefine.h>

NS_ASSUME_NONNULL_BEGIN

id _ctkProtected(id self, SEL sel) {
    ctk_debug_log([NSString stringWithFormat:@"Selector %@ is protected.", NSStringFromSelector(sel)]);
    return nil;
}

@interface CTKUnrecognizedSelectorProtector : NSObject

@end

NS_ASSUME_NONNULL_END
