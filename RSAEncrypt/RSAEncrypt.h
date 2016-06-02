#import <Foundation/Foundation.h>

@interface RSAEncrypt : NSObject

//将openssl生成public_key.der文件转为 string，以方便使用及安全
+ (NSString *)PublicKeyStringFromFile:(NSString *)fileName;

//使用公钥 key 加密字符串,不使用SecPadding
+ (NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key;
//使用公钥 key 加密字符串，并使用指定的SecPadding
+ (NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key secPadding:(SecPadding)padding;
@end