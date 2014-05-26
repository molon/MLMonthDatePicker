//
//  MLMonthDatePicker.m
//  MLMonthDatePicker
//
//  Created by molon on 5/26/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MLMonthDatePicker.h"

@interface MLMonthDatePicker()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *months;

@end

@implementation MLMonthDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.months removeAllObjects];
        for (NSUInteger i=0; i<12; i++) {
            [self.months addObject:[NSString stringWithFormat:@"%ld月",i+1]];
        }
        
        self.dataSource = self;
        self.delegate = self;
        
        //设置默认的最小日期和最大日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        self.minimumDate = [dateFormatter dateFromString:@"1970-01"]; //这个作为默认最小值吧
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
        
        components.year+=1;
        self.maximumDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        self.date = self.maximumDate;
    }
    return self;
}

#pragma mark - setter and getter 
- (NSMutableArray *)months
{
	if (!_months) {
		_months = [NSMutableArray array];
	}
	return _months;
}


- (void)setDate:(NSDate *)date
{
    //不在区间里就扔掉
    if (![[date laterDate:self.minimumDate] isEqualToDate:date]||![[date earlierDate:self.maximumDate]isEqualToDate:date]) {
        return;
    }
    
    _date = date;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|kCFCalendarUnitMonth fromDate:date];
    
    NSDateComponents *minDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|kCFCalendarUnitMonth fromDate:self.minimumDate];
    
    [self selectRow:dateComponents.year-minDateComponents.year inComponent:0 animated:NO];
    [self selectRow:dateComponents.month-minDateComponents.month inComponent:1 animated:NO];
    
    [self pickerView:self didSelectRow:dateComponents.year-minDateComponents.year inComponent:0];
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    if (!minimumDate) {
        return;//不可为nil
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *min1970Date = [dateFormatter dateFromString:@"1970-01"];
    if (![[minimumDate laterDate:min1970Date]isEqualToDate:minimumDate]) {
        return;
    }
    
    _minimumDate = minimumDate;
    
    //如果最大的日期小于最小的就重置其和最小的相等
    if ([[minimumDate earlierDate:self.maximumDate] isEqualToDate:self.maximumDate]) {
        self.maximumDate = minimumDate;
    }
    
    [self reloadAllComponents];
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    if (!maximumDate) {
        return; //不可为nil
    }
    _maximumDate = maximumDate;
    
    //与上面同理
    if ([[self.minimumDate earlierDate:maximumDate] isEqualToDate:maximumDate]) {
        self.minimumDate = maximumDate;
    }
    
    [self reloadAllComponents];
}

#pragma mark - data source and delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.minimumDate];
        NSUInteger minYear = components.year;
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.maximumDate];
        NSUInteger maxYear = components.year;
        return maxYear-minYear+1;
    }
    return self.months.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        //找到最小年份
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.minimumDate];
        NSUInteger minYear = components.year;
        
        return [NSString stringWithFormat:@"%ld年",minYear+row];
    }
    return self.months[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDateComponents *minDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:self.minimumDate];
    NSUInteger minYear = minDateComponents.year;
    if (component==0) {
        //检查是否是最大和最小年份，是的话，重置月份数组
        NSDateComponents *maxDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:self.maximumDate];
        NSUInteger maxYear = maxDateComponents.year;
        
        if (row == maxYear-minYear) { //最大年份
            //找到最大年份的月份
            NSUInteger maxMonth = maxDateComponents.month;
            [self.months removeAllObjects];
            for (NSUInteger i=0; i<maxMonth; i++) {
                [self.months addObject:[NSString stringWithFormat:@"%ld月",i+1]];
            }
            [self reloadComponent:1];
        }else if(row==0){ //最小年份
            //找到最小年份的月份
            NSUInteger minMonth = minDateComponents.month;
            [self.months removeAllObjects];
            for (NSUInteger i=minMonth-1; i<12; i++) {
                [self.months addObject:[NSString stringWithFormat:@"%ld月",i+1]];
            }
            [self reloadComponent:1];
        }else{
            if (self.months.count!=12) { //不是12就重置回
                [self.months removeAllObjects];
                for (NSUInteger i=0; i<12; i++) {
                    [self.months addObject:[NSString stringWithFormat:@"%ld月",i+1]];
                }
                [self reloadComponent:1];
            }
        }
    }
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.year = [self selectedRowInComponent:0]+minYear;
    
    if (component==0&&row==0) {
        //换的年份，而且是换到了最小年份
        NSUInteger minMonth = minDateComponents.month;
        components.month = [self selectedRowInComponent:1]+minMonth;
    }else{
        components.month = [self selectedRowInComponent:1]+1;
    }
    
    components.day = 2;
    
    [self willChangeValueForKey:@"date"];
    
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    [self didChangeValueForKey:@"date"];
    
    if (self.monthPickerDelegate&&[self.monthPickerDelegate respondsToSelector:@selector(mlMonthDatePicker:didSelectDate:)]) {
        [self.monthPickerDelegate mlMonthDatePicker:self didSelectDate:self.date];
    }    
}

@end
