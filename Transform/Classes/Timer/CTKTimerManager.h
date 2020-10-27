//
//  CTKTimerManager.h
//  Transform
//
//  Created by sun well on 2020/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTKTimerManager : NSObject
@property (nonatomic, weak) id weakTarget;
@property (nonatomic, assign) SEL weakSEL;
@property (nonatomic, weak) NSTimer *weakTimer;

- (void)fireTimer:(id)userInfo;
@end

NS_ASSUME_NONNULL_END
