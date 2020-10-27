//
//  NSTimer+CTK.h
//  Transform
//
//  Created by sun well on 2020/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (CTK)

+ (id)ctk_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                   block:(void (^)(NSTimer *timer))block
                                 repeats:(BOOL)repeats;

+ (id)ctk_timerWithTimeInterval:(NSTimeInterval)timeInterval
                          block:(void (^)(NSTimer *timer))block
                        repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
