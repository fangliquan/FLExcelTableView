//
//  FLExcelTableView.m
//  FLExcelDemo
//
//  Created by microleo on 2017/12/1.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "FLExcelTableView.h"
#import "Masonry.h"

#define  COLORBORDER [UIColor blackColor]
#define  COLORFONT [UIColor blackColor]
#define  HEADERFONT  [UIFont systemFontOfSize:17]
#define  CONTENTFONT  [UIFont systemFontOfSize:15]

@interface FLExcelTableView(){
    
}
@property(nonatomic,strong) NSMutableArray *reusableSectionHeaders;
@property(nonatomic,strong) NSMutableArray *reusableColumnHeaders;
@property(nonatomic,strong) NSMutableArray *reusableCells;
@property(nonatomic,strong) NSMutableArray *reusableTopLeftHeaders;

@property(nonatomic,assign) NSInteger numberSection;
@property(nonatomic,assign) NSInteger numberColumn;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,strong) ExcelIndexPath *firstIndexPath;
@property(nonatomic,strong) ExcelIndexPath *maxIndexPath;

@end;
@implementation FLExcelTableView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self commonInit];
    }
    return self;
}

-(void)commonInit{
    _reusableSectionHeaders = [[NSMutableArray alloc] init];
    _reusableColumnHeaders    = [[NSMutableArray alloc] init];
    _reusableCells   = [[NSMutableArray alloc] init];
    _reusableTopLeftHeaders = [[NSMutableArray alloc] init];
    _firstIndexPath = [ExcelIndexPath indexPathForSection:-1 inColumn:-1];
    _maxIndexPath = [ExcelIndexPath indexPathForSection:-1 inColumn:-1];
    self.bounces = NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self cleanupUnseenItems];
    [self loadseenItems];
}

-(void)loadseenItems{
    
}

-(void)cleanupUnseenItems{
    
}

-(BOOL)isOnScreenRect:(CGRect)rect{
    return CGRectIntersectsRect(rect, CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height));
}
-(ExcelColumnHeaderView *)columnHeadWithIdentifier:(NSString *)identifier{
    ExcelColumnHeaderView *columnHeader = nil;
    for (ExcelColumnHeaderView *reusableHeader in _reusableColumnHeaders) {
        if ([reusableHeader.identifier isEqualToString:identifier]) {
            columnHeader = reusableHeader;
            break;
        }
    }
    if (columnHeader) {
        [_reusableColumnHeaders removeObject:columnHeader];
    }
    return columnHeader;
}

-(ExcelSectionHeaderView *)sectionHeadWithIdentifier:(NSString *)identifier{
    ExcelSectionHeaderView *sectionHeader = nil;
    for (ExcelSectionHeaderView *reusableHeader in _reusableSectionHeaders) {
        if ([reusableHeader.identifier isEqualToString:identifier]) {
            sectionHeader = reusableHeader;
            break;
        }
    }
    if (sectionHeader) {
        [_reusableSectionHeaders removeObject:sectionHeader];
    }
    return sectionHeader;
    
}

-(ExcelTopLeftHeaderView *)topLeftHeadWithIdentifier:(NSString *)identifier{
    ExcelTopLeftHeaderView *topLeftHeader = nil;
    for (ExcelTopLeftHeaderView *reusableHeader in _reusableTopLeftHeaders) {
            topLeftHeader = reusableHeader;
            break;
    }
    if (topLeftHeader) {
        [_reusableSectionHeaders removeObject:topLeftHeader];
    }
    return topLeftHeader;
    
}
-(void)queueReusableCell:(ExcelItemCell *)cell{
    if (cell) {
        cell.indexPath = nil;
        [cell removeTarget:self action:@selector(cellClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reusableCells addObject:cell];
    }
}
-(void)queueReusableColumnHeader:(ExcelColumnHeaderView *)columnHeader{
    if (columnHeader) {
        [columnHeader setColumn:-1];
        [columnHeader removeTarget:self action:@selector(columnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reusableColumnHeaders addObject:columnHeader];
    }
}

-(void)queueReusableSectionHeader:(ExcelSectionHeaderView *)sectionHeader{
    if (sectionHeader) {
        [sectionHeader setSection:-1];
        [sectionHeader removeTarget:sectionHeader action:@selector(secionClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reusableSectionHeaders addObject:sectionHeader];
    }
}

-(void)queueReusableTobLeftHeader:(ExcelTopLeftHeaderView *)topLeftView{
    if (topLeftView) {
        [_reusableTopLeftHeaders addObject:topLeftView];
    }
}


-(void)sectionClickAction:(ExcelSectionHeaderView *)sectionView{
    if (_excelDelegate) {
        if ([_excelDelegate respondsToSelector:@selector(tableView:didSelectSectionAtIndex:)]) {
            [_excelDelegate tableView:self didSelectSectionAtIndex:sectionView.section];
        }
    }
}


-(void)columnClickAction:(ExcelColumnHeaderView *)columnView{
    if (_excelDelegate) {
        if ([_excelDelegate respondsToSelector:@selector(tableView:didSelectColumnAtIndex:)]) {
            [_excelDelegate tableView:self didSelectColumnAtIndex:columnView.column];
        }
    }
}


-(void)cellClickAction:(ExcelItemCell *)cell{
    if (_excelDelegate) {
        if ([_excelDelegate respondsToSelector:@selector(tableView:didSelectCellAtIndexPath:)]) {
            [_excelDelegate tableView:self didSelectCellAtIndexPath:cell.indexPath];
        }
    }
}



@end

@implementation ExcelItemCell


-(instancetype) initWithIdentifier:(NSString *)identifier{
    self = [super init];
    _identifier = [identifier copy];
    return  self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)setIndexPath:(ExcelIndexPath *)indexPath{
    _indexPath = indexPath;
}
-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *_borderLabel = [[UILabel alloc]init];
    _borderLabel.layer.borderColor = COLORBORDER.CGColor;
    _borderLabel.layer.borderWidth = 1;
    [self addSubview:_borderLabel];
    
    [_borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}


@end

@interface ExcelColumnHeaderView(){
    UILabel *_borderLabel;
}
@end
@implementation ExcelColumnHeaderView

-(instancetype) initWithIdentifier:(NSString *)identifier{
    self = [super init];
    _identifier = [identifier copy];
    return  self;
}

-(void)setColumn:(NSInteger)column{
    _column = column;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    _borderLabel = [[UILabel alloc]init];
    _borderLabel.layer.borderColor = COLORBORDER.CGColor;
    _borderLabel.layer.borderWidth = 1;
    [self addSubview:_borderLabel];
    
    [_borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}
@end

@implementation ExcelSectionHeaderView
-(instancetype) initWithIdentifier:(NSString *)identifier{
    self = [super init];
    _identifier = [identifier copy];
    return  self;
}

-(void)setSection:(NSInteger)section{
    _section = section;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *_borderLabel = [[UILabel alloc]init];
    _borderLabel.layer.borderColor = COLORBORDER.CGColor;
    _borderLabel.layer.borderWidth = 1;
    [self addSubview:_borderLabel];
    
    [_borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}
@end




@interface ExcelTopLeftHeaderView (){
    UILabel *_sectionTitleLabel;
    UILabel *_columnTitleLabel;
    UILabel *_borderLabel;
}
@end
@implementation ExcelTopLeftHeaderView
-(instancetype)initWithSectionTitle:(NSString *)sectionTitle andColumnTitle:(NSString *)columnTitle{
    self = [super init];
    _sectionTitle = sectionTitle;
    _columnTitle = columnTitle;
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    _borderLabel = [[UILabel alloc]init];
    _borderLabel.layer.borderColor = COLORBORDER.CGColor;
    _borderLabel.layer.borderWidth = 1;
    [self addSubview:_borderLabel];
    
    _columnTitleLabel = [[UILabel alloc]init];
    _columnTitleLabel.text = _columnTitle;
    _columnTitleLabel.font = CONTENTFONT;
    _columnTitleLabel.textColor = COLORFONT;
    [self addSubview:_columnTitleLabel];
    
    _sectionTitleLabel = [[UILabel alloc]init];
    _sectionTitleLabel.text = _sectionTitle;
    _sectionTitleLabel.font = CONTENTFONT;
    _sectionTitleLabel.textColor = COLORFONT;
    [self addSubview:_sectionTitleLabel];
    
    [_borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [_sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-2);
        make.top.equalTo(self.mas_top).offset(1);
    }];
    
    [_columnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
    }];
}

-(void)setColumnTitle:(NSString *)columnTitle{
    if (columnTitle) {
        _columnTitle = columnTitle;
        _columnTitleLabel.text = columnTitle;
    }
}

-(void)setSectionTitle:(NSString *)sectionTitle{
    if (sectionTitle) {
        _sectionTitle = sectionTitle;
        _sectionTitleLabel.text = sectionTitle;
    }
}




@end

@implementation ExcelIndexPath
+(instancetype)indexPathForSection:(NSInteger)section inColumn:(NSInteger)column{
    ExcelIndexPath *indexPath = [[ExcelIndexPath alloc]init];
    indexPath.section = section;
    indexPath.column = column;
    return indexPath;
}

@end
