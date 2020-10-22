//
//  NSObject+CTK.h
//  Transform
//
//  Created by sun well on 2020/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CTK)

@property (nonatomic, strong) id ctkprotector;

/// Swizzle forwardingTargetForSelector
/// @param aSelector aSelector
- (id)ctk_forwardingTargetForSelector:(SEL)aSelector;
@end

NS_ASSUME_NONNULL_END
