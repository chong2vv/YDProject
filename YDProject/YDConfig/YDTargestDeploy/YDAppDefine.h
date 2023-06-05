//
//  YDAppDefine.h
//  YDProject
//
//  Created by 王远东 on 2023/6/5.
//

#ifndef YDAppDefine_h
#define YDAppDefine_h

#if kProjectOnline
#import "YDAppOnlineDefine.h"
#elif kProjectPre
#import "YDAppPreDefine.h"
#elif kProjectDev
#import "YDAppDevDefine.h"
#endif

#endif /* YDAppDefine_h */
