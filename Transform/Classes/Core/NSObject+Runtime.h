//
//  NSObject+Runtime.h
//  Transform
//
//  Created by sun well on 2020/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Runtime)


/// Swizzle Class method.
/// @param oriSel oriSel
/// @param swiSel swiSel
+ (void)swizzleClassMethodWithOriginalSel:(SEL)oriSel
                              swizzledSel:(SEL)swiSel;


/// Swizzle instance method.
/// @param oriSel oriSel
/// @param swiSel swiSel
+ (void)swizzleInstanceMethodWithOriginalSel:(SEL)oriSel
                                 swizzledSel:(SEL)swiSel;

/// Is one method overrided by subclass.
/// @param cls cls
/// @param aSelector aSelector
- (BOOL)isMethodOverride:(Class)cls
                selector:(SEL)aSelector;

/// Is one class's bundle is main bundle.
/// @param cls cls
+ (BOOL)isMainBundleClass:(Class)cls; DEPRECATED_MSG_ATTRIBUTE("Please use +(BOOL)isCustomClass: instead.");


/// Is custom class?
/// @param cls cls
+ (BOOL)isCustomClass:(Class)cls;

/// Register a class with a selector at runtime.
/// @param aSelector aSelector
+ (Class)registerClassWithSel:(SEL)aSelector;
@end

NS_ASSUME_NONNULL_END
