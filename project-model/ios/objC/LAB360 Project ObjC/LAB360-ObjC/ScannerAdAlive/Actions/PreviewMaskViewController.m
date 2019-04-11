//
//  PreviewMaskViewController.m
//  AdAlive
//
//  Created by macbook on 30/04/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <Social/Social.h>
#import "PreviewMaskViewController.h"
#import "LogHelper.h"

@interface PreviewMaskViewController ()

@property(nonatomic, strong) IBOutlet UIImageView *previewImageView;

@end

@implementation PreviewMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.previewImageView.image = self.previewImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Methods

-(IBAction)tapCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)tapSaveButton:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.previewImage, nil, nil, nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Salvo", @"Message") message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(IBAction)tapShareButton:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbShare = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbShare addImage:self.previewImage];
        fbShare.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone)
            {
                //TODO: log mask with id - montar dicionario com mask_id
                NSDictionary *dicLog = [NSDictionary dictionaryWithObject:self.maskId forKey:@"mask_id"];
                [LogHelper logData:dicLog withLogType:MaskLog];
            }
            else if(result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Post Cancelado");
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE_FACEBOOK_ERROR", @"Error Message") message:NSLocalizedString(@"MESSAGE_FACEBOOK_ERROR", @"Error Message") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
            
            //  dismiss the Tweet Sheet
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:^{
                    NSLog(@"Facebook Sheet has been dismissed.");
                }];
            });
        };
        
        [self presentViewController:fbShare animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE_ACCOUNT_ERROR", @"Error Messages") message:NSLocalizedString(@"MESSAGE_ACCOUNT_ERROR", @"Error Messages") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
