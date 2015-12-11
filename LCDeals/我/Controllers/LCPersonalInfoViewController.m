//
//  LCPersonalInfoViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/26.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCPersonalInfoViewController.h"
#import <Photos/Photos.h>

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
    if (!imageData) {
         [_headButton setBackgroundColor:[UIColor grayColor]];
    }else{
        [_headButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)headButtonAciton:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted||status == PHAuthorizationStatusDenied) {
            [SVProgressHUD showErrorWithStatus:@"您没有授权我们访问您的相册和照相机,请在\"设置->隐私->照片\"处进行设置"];
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您没有摄像头"];
        }
        
    }];
    
    UIAlertAction *actionLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted||status == PHAuthorizationStatusDenied) {
            [SVProgressHUD showErrorWithStatus:@"您没有授权我们访问您的相册和照相机,请在\"设置->隐私->照片\"处进行设置"];
            return;
        }
         UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您没有相册"];
        }


    }];
    [alertController addAction:actionCamera];
    [alertController addAction:actionLibrary];
    [self presentViewController:alertController animated:YES completion:nil];


}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //如果是相机则将图片存入相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }

    [_headButton setBackgroundImage:image forState:UIControlStateNormal];
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
    if (![UIImagePNGRepresentation(_headButton.currentBackgroundImage) isEqualToData:userInfo[@"headImage"]] && _headButton.currentBackgroundImage) {
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
