//
//  CTKCommonDefine.h
//  Transform
//
//  Created by sun well on 2020/10/22.
//

#ifndef CTKCommonDefine_h
#define CTKCommonDefine_h

static inline void ctk_debug_log(NSString *message) {
#if DEBUG
    NSLog(@"%@", message);
#endif
}

#endif /* CTKCommonDefine_h */
