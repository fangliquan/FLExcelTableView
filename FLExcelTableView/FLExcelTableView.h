//
//  FLExcelTableView.h
//  FLExcelDemo
//
//  Created by microleo on 2017/12/1.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ExcelColumnHeaderView,ExcelSectionHeaderView,ExcelTopLeftHeaderView,ExcelItemCell,ExcelIndexPath,FLExcelTableView;

@protocol ExcelDelegate<NSObject>

@optional
//选中的Cell
-(void)tableView:(FLExcelTableView *)tableView didSelectCellAtIndexPath:(ExcelIndexPath*)indexPath;
-(void)tableView:(FLExcelTableView *)tableView didSelectSectionAtIndex:(NSInteger)section;
-(void)tableView:(FLExcelTableView *)tableView didSelectColumnAtIndex:(NSInteger)Column;

@end;

@protocol ExcelDataSource<NSObject>

@required
-(NSInteger)numberOfSection:(FLExcelTableView *)tableView;
-(NSInteger)numberOfColumn:(FLExcelTableView *)tableView;
-(CGFloat)heightForSection:(FLExcelTableView *)tableView;
-(CGFloat)widthForColumn:(FLExcelTableView *)tableView;
-(ExcelTopLeftHeaderView *)topLeftHeadViewForTableView:(FLExcelTableView *)tableView;
-(ExcelSectionHeaderView *)tableView:(FLExcelTableView *)tableView sectionHeaderAtSection:(NSInteger)section;
-(ExcelColumnHeaderView*)tableView:(FLExcelTableView *)tableView columnHeaderAtColumn:(NSInteger)column;
-(ExcelItemCell *)tableView:(FLExcelTableView *)tableView cellForColumnAtIndexPath:(ExcelIndexPath *)indexPath;

@end

@interface FLExcelTableView : UIScrollView
@property(nonatomic,assign) id<ExcelDelegate>  excelDelegate;
@property(nonatomic,assign) id<ExcelDataSource>  excelDataSource;
-(ExcelSectionHeaderView *)sectionHeadWithIdentifier:(NSString *)identifier;
-(ExcelColumnHeaderView *)columnHeadWithIdentifier:(NSString *)identifier;
-(ExcelTopLeftHeaderView *)topLeftHeadWithIdentifier:(NSString *)identifier;
-(ExcelItemCell *)cellWithIdentifier:(NSString *)indentifier;
-(void)reloadData;



@end


@interface ExcelItemCell:UIButton
@property(nonatomic,copy,readonly) NSString *identifier;
@property(nonatomic,copy,readonly) ExcelIndexPath *indexPath;
-(instancetype)initWithIdentifier:(NSString *)identifier;
-(void)setIndexPath:(ExcelIndexPath *)indexPath;

@end

@interface ExcelColumnHeaderView:UIButton

@property(nonatomic,copy,readonly) NSString *identifier;

@property(nonatomic,assign,readonly) NSInteger column;

-(instancetype)initWithIdentifier:(NSString *)identifier;

-(void)setColumn:(NSInteger)column;

@end

@interface ExcelSectionHeaderView:UIButton
@property(nonatomic,copy,readonly) NSString *identifier;

@property(nonatomic,assign,readonly) NSInteger section;

-(instancetype)initWithIdentifier:(NSString *)identifier;

-(void)setSection:(NSInteger)section;
@end




@interface ExcelTopLeftHeaderView:UIView

@property(nonatomic,copy,readonly) NSString *sectionTitle;

@property(nonatomic,copy,readonly) NSString *columnTitle;

-(instancetype) initWithSectionTitle:(NSString *)sectionTitle andColumnTitle:(NSString *)columnTitle;
@end

//indexPath
@interface ExcelIndexPath:NSObject

+(instancetype)indexPathForSection:(NSInteger)section inColumn:(NSInteger)column;
@property(nonatomic,assign) NSInteger section;
@property(nonatomic,assign) NSInteger column;

@end

