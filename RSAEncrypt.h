#import <Foundation/Foundation.h>
#import "Base64.h"

@interface RSAEncrypt : NSObject {

}
//将openssl生成public_key.del文件转为 string，以方便使用及安全
+ (void)getPublicKeyFromFile;

//加密字符串
+ (NSString *) rsaEncryptString:(NSString*) string;
@end