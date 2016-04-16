#import "RSAEncrypt.h"

@implementation RSAEncrypt

#define RSA_KEY_BASE64 @"MIIDbDCCAtWgAwIBAgIJAMaoDlMyLbImMA0GCSqGSIb3DQEBBQUAMIGBMQswCQYDVQQGEwJyaTEOMAwGA1UECBMFcmlnZWwxDjAMBgNVBAcTBXJpZ2VsMQ4wDAYDVQQKEwVyaWdlbDEOMAwGA1UECxMFcmlnZWwxDjAMBgNVBAMTBXJpZ2VsMSIwIAYJKoZIhvcNAQkBFhNyaWdlbHh1QGZveG1haWwuY29tMB4XDTE2MDExOTAzMjM1NFoXDTI2MDExNjAzMjM1NFowgYExCzAJBgNVBAYTAnJpMQ4wDAYDVQQIEwVyaWdlbDEOMAwGA1UEBxMFcmlnZWwxDjAMBgNVBAoTBXJpZ2VsMQ4wDAYDVQQLEwVyaWdlbDEOMAwGA1UEAxMFcmlnZWwxIjAgBgkqhkiG9w0BCQEWE3JpZ2VseHVAZm94bWFpbC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMAT1XwWvkqTg+tDXmArwsG33GsUGizSzP0QzCzr7YKCJFKz2W/Jkv+sLT0JuWD/zWi5WhVYJPY6hEi2jLfTVBz3vOtqimiwY036Akhh57gSpQ7CAm+2KFwy/7kSUDBfs19TanlF+NaRX6byJIuTipGYnFM4zbH+OI7WYhBPM6L1AgMBAAGjgekwgeYwHQYDVR0OBBYEFM3kGeWGdcUQtjpVSBeTgURozmPDMIG2BgNVHSMEga4wgauAFM3kGeWGdcUQtjpVSBeTgURozmPDoYGHpIGEMIGBMQswCQYDVQQGEwJyaTEOMAwGA1UECBMFcmlnZWwxDjAMBgNVBAcTBXJpZ2VsMQ4wDAYDVQQKEwVyaWdlbDEOMAwGA1UECxMFcmlnZWwxDjAMBgNVBAMTBXJpZ2VsMSIwIAYJKoZIhvcNAQkBFhNyaWdlbHh1QGZveG1haWwuY29tggkAxqgOUzItsiYwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOBgQAOXqnuJ1XYjs3MXcTVPxPmVYuAEHNLwebb84TV7RH0m2JWocowznyGu0UzWuFeELMfztoasYLoFrY6+b2mC0VtUm+KQyo1Ti7NMxuOOGsZOgF0KyEc6psz36yqv0mDL4N0fjx7t0+a27VlSrUbCipeMZXwFmv+s7ykHFkO6Jq0Cg=="


static SecKeyRef _public_key=nil;
+ (void)getPublicKeyFromFile {
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    NSData *publicKeyData = [NSData dataWithContentsOfFile:publicKeyPath];
    
    NSString *publicKeyStr = [Base64 encode:publicKeyData];
    NSLog(@"publicKeyStr = %@", publicKeyStr);
}

+ (SecKeyRef) getPublicKey{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
    if(_public_key == nil){
        NSData *certificateData = [Base64 decode:RSA_KEY_BASE64];
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
        _public_key = SecTrustCopyPublicKey(myTrust);
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    return _public_key;
}

+ (NSString*) rsaEncryptString:(NSString*) string{
    SecKeyRef key = [self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    NSData *stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        NSInteger bufferSize = MIN(blockSize,[stringBytes length] - i * blockSize);
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingNone, (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);

    return [Base64 encode:encryptedData];
}

@end