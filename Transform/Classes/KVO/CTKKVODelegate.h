//
//  CTKKVODelegate.h
//  Transform
//
//  Created by sun well on 2020/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTKKVOObserver : NSObject
@property (nonatomic, weak) id observer;
@end

@interface CTKKVODelegate : NSObject
@property (nonatomic, strong) NSMutableDictionary *kvoObserverMaps;
@property (nonatomic, weak) id weakObservedObject;
@end

NS_ASSUME_NONNULL_END
