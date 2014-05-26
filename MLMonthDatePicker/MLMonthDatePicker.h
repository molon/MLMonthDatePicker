//
//  MLMonthDatePicker.h
//  MLMonthDatePicker
//
//  Created by molon on 5/26/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLMonthDatePicker;
@protocol MLMonthDatePickerDelegate <NSObject>

- (void)mlMonthDatePicker:(MLMonthDatePicker*)picker didSelectDate:(NSDate*)date;

@end

@interface MLMonthDatePicker : UIPickerView

@property (nonatomic, weak) id<MLMonthDatePickerDelegate> monthPickerDelegate;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@end
