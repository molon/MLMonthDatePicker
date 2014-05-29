//
//  ViewController.m
//  MLMonthDatePicker
//
//  Created by molon on 5/26/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "ViewController.h"
#import "MLMonthDatePicker.h"

@interface ViewController ()<MLMonthDatePickerDelegate>

@property (nonatomic, strong) MLMonthDatePicker *picker;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.picker];
    self.picker.frame = CGRectMake(0, self.view.bounds.size.height-self.picker.bounds.size.height, self.view.bounds.size.width, self.picker.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MLMonthDatePicker *)picker
{
	if (!_picker) {
		_picker = [[MLMonthDatePicker alloc]init];
        _picker.backgroundColor = [UIColor yellowColor];
        _picker.monthPickerDelegate = self;
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM"];
//        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        _picker.minimumDate = [dateFormatter dateFromString:@"1980-06"]; //这个作为默认最小值吧
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        _picker.maximumDate = [dateFormatter dateFromString:@"2016-10"];
        
//        [_picker setDate:_picker.maximumDate];
	}
	return _picker;
}

- (void)mlMonthDatePicker:(MLMonthDatePicker*)picker didSelectDate:(NSDate*)date
{
    NSLog(@"%@",date);
}

@end
