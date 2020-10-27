//
//  CTKKVODelegate.h
//  Transform
//
//  Created by sun well on 2020/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTKKVOInfo : NSObject
@property (nonatomic, weak) id observer;
@end

@interface CTKKVODelegate : NSObject
@property (nonatomic, strong) NSMutableDictionary *kvoInfoMaps;
@property (nonatomic, weak) id weakObservedObject;
@end

NS_ASSUME_NONNULL_END
