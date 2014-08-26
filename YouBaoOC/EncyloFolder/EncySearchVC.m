//
//  EncySearchVC.m
//  YouBaoOC
//
//  Created by developer on 14-8-26.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "EncySearchVC.h"
#import "UIViewController+HideTabBar.h"
@interface EncySearchVC ()<UISearchBarDelegate>
{
    UIToolbar *topBar;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)backView:(id)sender;
@end

@implementation EncySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    topBar = [[UIToolbar alloc] init];
    topBar = [self forKeyBoardHide:@"完成"];
    [self.searchBar setInputAccessoryView:topBar];
    UIView *views = [self.searchBar.subviews objectAtIndex:0];
    for(UIView *oneObject in views.subviews)
    {
        NSLog(@"class is %@",NSStringFromClass(oneObject.class));
        if([oneObject isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)oneObject;
            textField.returnKeyType = UIReturnKeyDone;
        }
    }
    self.searchBar.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)hideKeyBoard:(id)sender
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
