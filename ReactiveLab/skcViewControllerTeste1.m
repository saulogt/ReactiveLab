//
//  skcViewControllerTeste1.m
//  ReactiveLab
//
//  Created by Saulo G Tauil on 22/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import "skcViewControllerTeste1.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>


@interface skcViewControllerTeste1 ()

@property (weak, nonatomic) UIButton* btn;

@end

@implementation skcViewControllerTeste1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btn setFrame:CGRectMake(0, 0, 200, 200)];
    
    [self.btn setTitle:@"Botão" forState:UIControlStateNormal];
    [self.view addSubview: self.btn];
    
    

    
    
}

-(RACSignal*) buttonDownAnimationSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [UIView animateWithDuration: 1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self.btn setFrame: CGRectOffset(self.btn.frame, 0, 100)];
            
            [subscriber sendNext: @(100)];
            //
        } completion:^(BOOL finished) {
            //
            // [self.btn setFrame: CGRectOffset(self.btn.frame, 0, 200)];
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //
            NSLog(@"buttonDownAnimationSignal disposed");
        }];
    }];


}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    //[self.btn setFrame: CGRectOffset(self.btn.frame, 0, 200)];
    @weakify(self);
    
    [[[[self buttonDownAnimationSignal]
       delay: 2]
      flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self buttonDownAnimationSignal];
    }]
     subscribeNext:^(id x) {
        NSLog(@"animNext");
    }
     error:^(NSError *error) {
        NSLog(@"anim Error");
    }
     completed:^{
        NSLog(@"Anim Completed");
    }];
    
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

-(void)dealloc
{
    NSLog(@"%@ destroyed", [self class]);
}


@end
