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

#define CTK_DEPRECATED(versionIntro, versionDep, descriptionDep, ...) __attribute__((deprecated("First deprecated in Transform "#versionDep","#descriptionDep","#__VA_ARGS__""))) __attribute__((weak_import))

#endif /* CTKCommonDefine_h */
