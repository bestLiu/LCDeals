//
//  LCPersonalInfoViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/26.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCPersonalInfoViewController.h"

@interface LCPersonalInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation LCPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"个人信息";
    
    [self setupDefaultData];
}

- (void)setupDefaultData
{
//    _headButton.backgroundColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn:)];
    [_scrollView addGestureRecognizer:tap];
    _confirmButton.layer.cornerRadius = 4;
    _confirmButton.layer.masksToBounds = YES;
    [_confirmButton setBackgroundImage:[LCTool imageWithColor:[UIColor orangeColor] andSize:_confirmButton.frame.size] forState:UIControlStateNormal];
   NSDictionary *userInfo = [userDefaults objectForKey:kUserInfoKey];
    _nickNameTF.text = userInfo[@"nickName"];
    _addressTF.text = userInfo[@"address"];
    _emailTF.text = userInfo[@"email"];
    _telTF.text = userInfo[@"tel"];

    NSData *imageData = userInfo[@"headImage"];
    [_headButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    
}
- (IBAction)headButtonAciton:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [_headButton setBackgroundImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _emailTF) {
        [UIView animateWithDuration:.3 animations:^{
            [_scrollView setContentOffset:CGPointMake(0, 150)];
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            [_scrollView setContentOffset:CGPointMake(0, 200)];
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:.3 animations:^{
        [_scrollView setContentOffset:CGPointZero];
    }];
    [self.view endEditing:YES];
    return YES;
}


- (IBAction)confirmButtonAction:(id)sender
{
    NSMutableDictionary *userInfo = [[userDefaults objectForKey:kUserInfoKey] mutableCopy];
    if (!userInfo) {
        userInfo = [[NSMutableDictionary alloc] init];
    }
    if (![_nickNameTF.text isEqualToString:userInfo[@"nickName"]]) {
        [userInfo setObject:_nickNameTF.text forKey:@"nickName"];
    }
    if (![_addressTF.text isEqualToString:userInfo[@"address"]]) {
        [userInfo setObject:_addressTF.text forKey:@"address"];
    }
    if (![_emailTF.text isEqualToString:userInfo[@"email"]]) {
        [userInfo setObject:_emailTF.text forKey:@"email"];
    }
    if (![_telTF.text isEqualToString:userInfo[@"tel"]]) {
        [userInfo setObject:_telTF.text forKey:@"tel"];
    }
    if (![UIImagePNGRepresentation(_headButton.currentBackgroundImage) isEqualToData:userInfo[@"headImage"]]) {
        [userInfo setObject:UIImagePNGRepresentation(_headButton.currentBackgroundImage) forKey:@"headImage"];
    }
    [userDefaults setObject:userInfo forKey:kUserInfoKey];
    [userDefaults synchronize];
    
    //字典代理出去
    if ([self.delegte respondsToSelector:@selector(updatePersonalInfoComplition:)]) {
        [self.delegte updatePersonalInfoComplition:userInfo];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
