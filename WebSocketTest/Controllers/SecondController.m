//
//  SecondController.m
//  WebSocketTest
//
//  Created by Stanislav on 5/24/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import "SecondController.h"

@interface SecondController ()
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;
@end

@implementation SecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"App View"];
    NSString *exDate = [[NSUserDefaults standardUserDefaults] objectForKey:apiTokenExparationDate];
    exDate = [[exDate componentsSeparatedByString:@"T"] firstObject];
    [self.expirationDateLabel setText:[NSString stringWithFormat:@"Exparation Date: %@", exDate] ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
