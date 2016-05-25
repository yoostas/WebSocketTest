//
//  FirstController.m
//  WebSocketTest
//
//  Created by Stanislav on 5/24/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import "FirstController.h"
#import "SecondController.h"
@interface FirstController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextView *errorView;
@property (weak, nonatomic) IBOutlet UIView *connectionCheck;

@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Login View"];
    self.connectionCheck.layer.cornerRadius = 5.0;
    [Connection sharedConnection];
    [Connection sharedConnection].delegate = self;
    [self checkForAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITexfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - User action

- (IBAction)loginTap:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *username = self.loginTextField.text;
    if ([self isValidEmail:username]) {
        NSString *password = self.passwordTextField.text;
        if ([password length] > 0) {
            [[Connection sharedConnection] loginWithEmail:username andPassword:password];
        } else {
            UIAlertController *emptyPassword = [UIAlertController alertControllerWithTitle:@"Password ERROR" message:@"Password field should not be empty" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            [emptyPassword addAction:cancel];
            [self presentViewController:emptyPassword animated:YES completion:nil];
        }
        
    } else {
        UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:@"E-Mail ERROR" message:@"Please set valid email" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [emailAlert addAction:cancel];
        [self presentViewController:emailAlert animated:YES completion:nil];
    }
}

#pragma mark - Connection delegate methods

- (void)connectioIsOk {
    [self.connectionCheck setBackgroundColor:[UIColor greenColor]];
}

- (void)connectionIsNotOk {
    [self.connectionCheck setBackgroundColor:[UIColor redColor]];
}

- (void)messageReseived:(NSDictionary *)message {
    NSString *type = message[@"type"];
    NSDictionary *data = message[@"data"];
    if ([type isEqualToString:errorType]) {
        if (data) {
            [self errorMessageWithData:data];
        }
    } else if ([type isEqualToString:successType]) {
        if (data) {
            [self successMessageWithData:data];
        }
    }
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"login"]) {
         [segue destinationViewController];
     }
 }

#pragma mark - UI Action

-(void) errorMessageWithData:(NSDictionary *)data {
    NSString *errorString = data[errorDescription];
    if (errorString) {
        [self.errorView setText:errorString];
    }
}

- (void) successMessageWithData:(NSDictionary *)data {
    NSString *exparationDate = data[apiTokenExparationDate];
    if (exparationDate) {
        [[NSUserDefaults standardUserDefaults] setObject:exparationDate forKey:apiTokenExparationDate];
    }
    NSString *token = data[apiToken];
    if (token) {
        if ([SSKeychain setPassword:token forService:kServicename account:kServicename error:nil]) {
            [self performSegueWithIdentifier:@"login" sender:nil];
        }
    }
}

#pragma mark - Validation

-(void) checkForAll {
    if ([self checkForApiToken]) {
        if ([self checkForDate]) {
            [self performSegueWithIdentifier:@"login" sender:nil];
        }
    }
}

- (BOOL) checkForApiToken {
    NSString *keychainToken = [SSKeychain passwordForService:kServicename account:kServicename];
    if (keychainToken) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) checkForDate {
    NSString *dateString = [[NSUserDefaults standardUserDefaults] objectForKey:apiTokenExparationDate];
    if (dateString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *exparationDate = [dateFormatter dateFromString:dateString];
        NSDate *now = [NSDate date];
        if ([now compare:exparationDate] == NSOrderedDescending) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
