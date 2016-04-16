#import "ViewController.h"
#import "RSAEncrypt.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [RSAEncrypt getPublicKeyFromFile];
    [RSAEncrypt rsaEncryptString:@"test"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
