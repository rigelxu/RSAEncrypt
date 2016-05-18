RSAEncrypt
===================

### Quick start

RSAEncrypt 支持 [CocoaPods](http://cocoapods.org).  添加下面配置到你的 Podfile:

```ruby
pod 'RSAEncrypt'
```


## Features

- +(NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key; //使用 publickey 对String 加密
- +(NSString *)PublicKeyStringFromFile:(NSString *)fileName; //从.der 文件提取 String publickey
- openssl密钥对生成方法。

## About Padding
不使用Padding,同一明文每次加密后的密文是一样的， 使用不同的 Padding 密文长度会有变化。具体使用哪种 Padding 要与服务端保持一致。

## TODO

* 添加解密方法。
* 解决 spec 依赖 Base64问题。
* 添加对RSA 文件的支持。
* 添加验签方法
* 单元测试
* Java加解密
* 对Padding的说明


## Requirements

- iOS 7.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.2+

## Installation

### Cocoapods

```ruby
pod 'RSAEncrypt'
```

### Manually
直接添加RSAEncrypt至工程，如果你的工程没有Base64可以需要同时导入[Base64](https://github.com/nicklockwood/Base64)


##openssl生成密钥对

**输入如下命令,根据提示输入信息:**

```bash
openssl req -x509 -out public_key.der -outform der -new -newkey rsa:1024 -keyout private_key.pem -days 3650
```

得到密钥对:public_key.der private_key.pem

**对私钥进行PKCS#8编码**

```bash
openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_rsa_private_key_zn.pem -nocrypt
```

**从编码后的私钥文件中copy出中间部分,给后台使用:**

> MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMAT1XwWvkqTg+tD
XmArwsG33GsUGizSzP0QzCzr7YKCJFKz2W/Jkv+sLT0JuWD/zWi5WhVYJPY6hEi2
jLfTVBz3vOtqimiwY036Akhh57gSpQ7CAm+2KFwy/7kSUDBfs19TanlF+NaRX6by
JIuTipGYnFM4zbH+OI7WYhBPM6L1AgMBAAECgYAM4kezpyLkhbiXk1FFSioqLFcQ
p6yJzSoK35GSgdDQrEIbegzfvrmphLcUHQ7ePspcd/Je9CamjY5KAlS2D+rYWNYU
eBXBm5hE3oIj5TUO00cka4hUuzdEqWboUhCAm7s4V/da74Gt88cuDlzbYTsHSx39
4DyvPCpi3Vla533UkQJBAN6t7NCzA39kWnDt9DlQrlBDw5pXKqqzDY4q4WGpyyIl
wpDnxN8d8V+fXNqJOKqAjzpLOafDeu+2hokS0oULwEsCQQDc0afSUOQQghGn4pKf
zJy5ae4Od8ZaMRAtW9jMUmG7lUuC740Z8wk3CvS/JzgAMVhuUJN/L/tf8TNpP9pG
gKG/AkBaeqcfwa0pJRiOjFFQvJSnbnFbFBH1HB3k501+xmQQcvFUuafH1L3P0cwD
y//nX6dS02AQ55/bKPoPVkON5dFzAkEApQTItZNd3DhXmW7oxCLUvHs9O/KmeKBR
xpPs4ERwZQ6c76y1db76E/hMDs3wO7SksUvl7haddIV8NhtRs35NYQJAKRzQV08G
364RGN+t4HRbfUq5l33czaqqi6eNsTJ8hhnzDpTxIIwPOQTNZiLNKNfvMt+YZkQu
fQziqqfz9V1emg==
	
**不进行PKCS#8编码的私钥也是可以用的,服务端解密时需要做如下处理:**

	RSAPrivateKeyStructure asn1PrivKey = new RSAPrivateKeyStructure((ASN1Sequence) ASN1Sequence.fromByteArray(priKeyData));
	
	RSAPrivateKeySpec rsaPrivKeySpec = new RSAPrivateKeySpec(asn1PrivKey.getModulus(), asn1PrivKey.getPrivateExponent());
	
	KeyFactory keyFactory= KeyFactory.getInstance("RSA");
	
	PrivateKey priKey= keyFactory.generatePrivate(rsaPrivKeySpec);
	
##生成公钥字符串
**对公钥文件进行base64 encode,得到iOS端加密方式使用的公钥字符串**


> MIIDbDCCAtWgAwIBAgIJAMaoDlMyLbImMA0GCSqGSIb3DQEBBQUAMIGBMQswCQYDVQQGEwJyaTEOMAwGA1UECBMFcmlnZWwxDjAMBgNVBAcTBXJpZ2VsMQ4wDAYDVQQKEwVyaWdlbDEOMAwGA1UECxMFcmlnZWwxDjAMBgNVBAMTBXJpZ2VsMSIwIAYJKoZIhvcNAQkBFhNyaWdlbHh1QGZveG1haWwuY29tMB4XDTE2MDExOTAzMjM1NFoXDTI2MDExNjAzMjM1NFowgYExCzAJBgNVBAYTAnJpMQ4wDAYDVQQIEwVyaWdlbDEOMAwGA1UEBxMFcmlnZWwxDjAMBgNVBAoTBXJpZ2VsMQ4wDAYDVQQLEwVyaWdlbDEOMAwGA1UEAxMFcmlnZWwxIjAgBgkqhkiG9w0BCQEWE3JpZ2VseHVAZm94bWFpbC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMAT1XwWvkqTg+tDXmArwsG33GsUGizSzP0QzCzr7YKCJFKz2W/Jkv+sLT0JuWD/zWi5WhVYJPY6hEi2jLfTVBz3vOtqimiwY036Akhh57gSpQ7CAm+2KFwy/7kSUDBfs19TanlF+NaRX6byJIuTipGYnFM4zbH+OI7WYhBPM6L1AgMBAAGjgekwgeYwHQYDVR0OBBYEFM3kGeWGdcUQtjpVSBeTgURozmPDMIG2BgNVHSMEga4wgauAFM3kGeWGdcUQtjpVSBeTgURozmPDoYGHpIGEMIGBMQswCQYDVQQGEwJyaTEOMAwGA1UECBMFcmlnZWwxDjAMBgNVBAcTBXJpZ2VsMQ4wDAYDVQQKEwVyaWdlbDEOMAwGA1UECxMFcmlnZWwxDjAMBgNVBAMTBXJpZ2VsMSIwIAYJKoZIhvcNAQkBFhNyaWdlbHh1QGZveG1haWwuY29tggkAxqgOUzItsiYwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOBgQAOXqnuJ1XYjs3MXcTVPxPmVYuAEHNLwebb84TV7RH0m2JWocowznyGu0UzWuFeELMfztoasYLoFrY6+b2mC0VtUm+KQyo1Ti7NMxuOOGsZOgF0KyEc6psz36yqv0mDL4N0fjx7t0+a27VlSrUbCipeMZXwFmv+s7ykHFkO6Jq0Cg==
	
**使用私钥导出公钥,生成Android端使用的公钥:**

```bash	
openssl rsa -in private_key.pem -out rsa_public_key_android.pem -pubout
```
	
得到的公钥是:

> MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDAE9V8Fr5Kk4PrQ15gK8LBt9xrFBos0sz9EMws6+2CgiRSs9lvyZL/rC09Cblg/81ouVoVWCT2OoRItoy301Qc97zraoposGNN+gJIYee4EqUOwgJvtihcMv+5ElAwX7NfU2p5RfjWkV+m8iSLk4qRmJxTOM2x/jiO1mIQTzOi9QIDAQAB
	
####其实iOS可以和Android使用同一公钥串(使用私钥导出的),但是此种公钥串iOS端加密需要操作kenchain,在一些极端情况下会出现加密失败问题. 而使用第一种方式的公钥,不需要操作keychain,可以避免加密失败的问题.


## License

RSAEncrypt is released under the MIT license.