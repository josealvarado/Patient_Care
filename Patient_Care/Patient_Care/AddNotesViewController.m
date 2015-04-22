//
//  AddNotesViewController.m
//  Patient_Care
//
//  Created by Jose Alvarado on 4/22/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "AddNotesViewController.h"
#import "Settings.h"

@interface AddNotesViewController ()

@end

@implementation AddNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _data = [[NSDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    if (_note) {
        _noteTextField.text = _note;
    }
}

//- (void)updateNote:()

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonPressed:(id)sender {
    
    NSLog(@"hello %@", _noteTextField.text);
    
    NSLog(@"before %lu", (unsigned long)[[Settings instance].notes count]);
    
    if ([Settings instance].notes) {
        NSLog(@"1");
    } else {
        NSLog(@"2");
        [Settings instance].notes = [[NSMutableArray alloc] init];
    }
    
//    if (_newNote) {
//        [[Settings instance].notes addObject:_noteTextField.text];
//    } else {
//        [[Settings instance].notes setObject:_noteTextField.text atIndexedSubscript:_noteNumber];
//    }
    
    int pos = [Settings instance].selectedNote;

    NSLog(@"b = %d", pos);
    
    if (pos == -1) {
        [[Settings instance].notes addObject:_noteTextField.text];
    } else {
//        NSString *b = [_data objectForKey:@"pos"];
        
//        int a = (int)b.integerValue;
        
        [[Settings instance].notes setObject:_noteTextField.text atIndexedSubscript:pos];
    }
    
    
    
    
    NSLog(@"after %lu", (unsigned long)[[Settings instance].notes count]);

    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
