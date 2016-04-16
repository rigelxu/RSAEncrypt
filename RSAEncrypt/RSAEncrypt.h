#import <Foundation/Foundation.h>
#import "Base64.h"

@interface RSAEncrypt : NSObject

//将openssl生成public_key.der文件转为 string，以方便使用及安全
+ (NSString *)PublicKeyStringFromFile:(NSString *)fileName;

//使用公钥 key 加密字符串
+ (NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key;
@end