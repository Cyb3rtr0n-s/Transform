//
//  NSObject+CTKZombie.h
//  Transform
//
//  Created by sun well on 2020/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CTKZombie)
@property (nonatomic, assign) BOOL needZombieProtector;

- (void)ctk_zombieDealloc;
@end

NS_ASSUME_NONNULL_END
