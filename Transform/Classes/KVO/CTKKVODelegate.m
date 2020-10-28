//
//  CTKKVODelegate.m
//  Transform
//
//  Created by sun well on 2020/10/27.
//

#import "CTKKVODelegate.h"
#import <NSObject+Runtime.h>

@implementation CTKKVODelegate

+ (void)load {
    [self swizzleInstanceMethodWithOriginalSel:@selector(observeValueForKeyPath:ofObject:change:context:) swizzledSel:@selector(ctk_observeValueForKeyPath:forObject:change:context:)];
}

- (void)ctk_observeValueForKeyPath:(NSString *)keyPath
                         forObject:(id)object
                            change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                           context:(void *)context {
    NSMutableArray *obArray = [NSMutableArray arrayWithArray:[self.kvoObserverMaps objectForKey:keyPath]];
    NSMutableArray *invalidArray = [NSMutableArray array];
    
    for (CTKKVOObserver *ob in obArray) {
        if (!ob.observer) {
            [invalidArray addObject:ob];
        } else {
            [ob.observer observeValueForKeyPath:keyPath
                                       ofObject:object
                                         change:change
                                        context:context];
        }
    }
    
    [obArray removeObjectsInArray:invalidArray];
    
    if (!obArray.count) {
        [self.weakObservedObject removeObserver:self forKeyPath:keyPath];
        self.kvoObserverMaps[keyPath] = nil;
    }
}

#pragma mark - Getter & Setter
- (NSMutableDictionary *)kvoObserverMaps {
    if (!_kvoObserverMaps) {
        _kvoObserverMaps = [[NSMutableDictionary alloc] init];
    }
    return _kvoObserverMaps;
}

@end
