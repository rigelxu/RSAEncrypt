#import <Foundation/Foundation.h>

@interface RSAEncrypt : NSObject

//将openssl生成public_key.der文件转为 string，以方便使用及安全;
//使用SecKeyRef相关方法，添加伪造证书的方式使用字符串加密，可能会导致加密永久失败，除非删除应用重新安装
+ (NSString *)PublicKeyStringFromFile:(NSString *)fileName;

//使用公钥 key 加密字符串,不使用SecPadding
+ (NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key;
//使用公钥 key 加密字符串，并使用指定的SecPadding
+ (NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key secPadding:(SecPadding)padding;
@end