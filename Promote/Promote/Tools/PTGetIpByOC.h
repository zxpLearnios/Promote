//
//  PTGetIpByOC.h
//  Promote
//
//  Created by 张净南 on 2018/10/30.
//

#import <Foundation/Foundation.h>

@interface PTGetIpByOC : NSObject
/// 获取ip地址，WiFi和4G下都可以
- (NSString *)getIPAddress:(BOOL)preferIPv4;
/// 获取ip字典信息
- (NSDictionary *)getIPAddresses;

@end
