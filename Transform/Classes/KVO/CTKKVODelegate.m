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
    NSMutableArray *infoArray = [NSMutableArray arrayWithArray:[self.kvoInfoMaps objectForKey:keyPath]];
    NSMutableArray *invalidArray = [NSMutableArray array];
    
    for (CTKKVOInfo *info in infoArray) {
        if (!info.observer) {
            [invalidArray addObject:info];
        } else {
            [info.observer observeValueForKeyPath:keyPath
                                         ofObject:object
                                           change:change
                                          context:context];
        }
    }
    
    [infoArray removeObjectsInArray:invalidArray];
    
    if (!infoArray.count) {
        [self.weakObservedObject removeObserver:self forKeyPath:keyPath];
        self.kvoInfoMaps[keyPath] = nil;
    }
}

#pragma mark - Getter & Setter
- (NSMutableDictionary *)kvoInfoMaps {
    if (!_kvoInfoMaps) {
        _kvoInfoMaps = [[NSMutableDictionary alloc] init];
    }
    return _kvoInfoMaps;
}

@end
