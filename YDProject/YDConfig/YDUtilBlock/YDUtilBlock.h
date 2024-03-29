//
//  YDUtilBlock.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#ifndef YDUtilBlock_h
#define YDUtilBlock_h

typedef void (^YDSuccessHandler)(void);
typedef void (^YDSuccessDict)(NSDictionary *dict);
typedef void (^YDSuccessString)(NSString *result);
typedef void (^YDSuccessList)(NSArray *list);
typedef void (^YDSuccessBOOL)(BOOL result);
typedef void (^YDSuccessResult)(id result);
typedef void (^YDSuccessInt)(int result);
typedef void (^YDSuccessLongLong)(long long result);
typedef void (^YDSuccessData)(NSData *data);

//错误无返回回调
typedef void (^YDFailureHandler)(void);
//错误信息返回
typedef void (^YDFailureString)(NSString *error);
//错误error返回
typedef void (^YDFailureError)(NSError *error);

typedef void (^YDConfirmActionBlock)(void);
typedef void (^YDCancelActionBlock)(void);

#endif /* YDUtilBlock_h */
