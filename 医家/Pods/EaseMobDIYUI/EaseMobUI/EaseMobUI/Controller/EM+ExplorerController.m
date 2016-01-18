//
//  EM+ExplorerController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ExplorerController.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatDateUtils.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

#import "EM+ChatWifiView.h"
#import "EM+ExplorerBaseCell.h"

#import "HTTPServer.h"
#import "EM+ChatExplorerConnection.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

#define HEIGHT_HEADER   (44)
#define HEIGHT_FOOTER   (44)

@interface EM_ExplorerController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) HTTPServer *httpServer;
@property (nonatomic, assign) NSInteger currentFolderIndex;;
@end

@implementation EM_ExplorerController{
    UIScrollView *_headerView;
    UIView *_footerView;
    UITableView *_tableView;
    UIButton *_enterButton;
    
    NSArray *_buttonArray;
    NSArray *_folderArray;
    NSMutableDictionary *_fileDictionary;
    NSMutableArray *_selectedArray;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = [EM_ChatResourcesUtils stringWithName:@"common.file"];
        _folderArray = [EM_ChatFileUtils folderArray];
        _fileDictionary = [[NSMutableDictionary alloc]init];
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(HEIGHT_HEADER, 0, HEIGHT_FOOTER, 0);
    [self.view addSubview:_tableView];
    
    _headerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_FRAME.size.height + NAVIGATION_BAR_FRAME.size.height, self.view.frame.size.width, HEIGHT_HEADER)];
    _headerView.backgroundColor = [UIColor whiteColor];
    CGFloat buttonWidth = self.view.frame.size.width / _folderArray.count;
    for (int i = 0; i < _folderArray.count; i++) {
        NSDictionary *dic = _folderArray[i];
        NSString *title = dic[kFolderTitle];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, HEIGHT_HEADER)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(folderClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.selected = _currentFolderIndex == i;
        [_headerView addSubview:button];
    }
    _buttonArray = [NSArray arrayWithArray:_headerView.subviews];
    
    UIView *headerLine = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height - LINE_HEIGHT, _headerView.frame.size.width, LINE_HEIGHT)];
    headerLine.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
    [_headerView addSubview:headerLine];
    [self.view addSubview:_headerView];
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - HEIGHT_FOOTER, self.view.frame.size.width, HEIGHT_FOOTER)];
    _footerView.backgroundColor = [UIColor whiteColor];
    UIView *footerLine = [[UIView alloc]initWithFrame:CGRectMake(0, -LINE_HEIGHT, _headerView.frame.size.width, LINE_HEIGHT)];
    footerLine.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
    [_footerView addSubview:footerLine];
    
    _enterButton = [[UIButton alloc]initWithFrame:CGRectMake(_footerView.frame.size.width - 90, 5, 80, _footerView.frame.size.height - 10)];
    _enterButton.backgroundColor = [UIColor colorWithHexRGB:TEXT_SELECT_COLOR];
    _enterButton.enabled = NO;
    [_enterButton setTitle:[EM_ChatResourcesUtils stringWithName:@"common.send"] forState:UIControlStateNormal];
    [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(sendFileClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_enterButton];
    [self.view addSubview:_footerView];
    
    UIButton *cancel = [[UIButton alloc]init];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:[EM_ChatResourcesUtils stringWithName:@"common.cancel"] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateHighlighted];
    [cancel sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    
    UIButton *wifi = [[UIButton alloc]init];
    [wifi addTarget:self action:@selector(wifiUpload:) forControlEvents:UIControlEventTouchUpInside];
    [wifi setTitle:[EM_ChatResourcesUtils stringWithName:@"file.wifi_upload"] forState:UIControlStateNormal];
    [wifi setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateNormal];
    [wifi setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateHighlighted];
    [wifi sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:wifi];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiFileUplod:) name:kEMNotificationFileUpload object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiFileDelete:) name:kEMNotificationFileDelete object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCurrentFolderIndex:(NSInteger)currentFolderIndex{
    if (_currentFolderIndex != currentFolderIndex) {
        _currentFolderIndex = currentFolderIndex;
        for (UIButton *button in _buttonArray) {
            button.selected = _currentFolderIndex == button.tag;
        }
    }
    [_tableView reloadData];
}

- (HTTPServer *)httpServer{
    if (!_httpServer) {
        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"EM_Web.bundle"];
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:13131];
        [_httpServer setName:@"EaseMobUI"];
        [_httpServer setDocumentRoot:webPath];
        [_httpServer setConnectionClass:[EM_ChatExplorerConnection class]];
    }
    return _httpServer;
}

- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

- (void)wifiFileUplod:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *fileType = [userInfo objectForKey:kFileType];
    
    NSMutableArray *fileArray = _fileDictionary[fileType];
    if (!fileArray) {
        fileArray = [[NSMutableArray alloc]init];
        [_fileDictionary setObject:fileArray forKey:fileType];
    }
    
    NSInteger index = -1;
    for (int i = 0; i < fileArray.count; i++) {
        NSDictionary *fileInfo = fileArray[i];
        if ([fileInfo[kFileName] isEqualToString:userInfo[kFileName]]) {
            index = i;
            break;
        }
    }
    
    if (index >= 0) {
        [fileArray replaceObjectAtIndex:index withObject:userInfo];
    }else{
        [fileArray insertObject:userInfo atIndex:0];
    }
    
    for (int i = 0;i < _folderArray.count;i++) {
        NSDictionary *folder = _folderArray[i];
        NSString *folderName = [folder objectForKey:kFolderName];
        if ([fileType isEqualToString:folderName]) {
            MAIN(^{
                self.currentFolderIndex = i;
            });
            break;
        }
    }
}

- (void)wifiFileDelete:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *fileType = userInfo[kFileType];
    NSString *fileName = userInfo[kFileName];
    NSMutableArray *fileArray = _fileDictionary[fileType];
    for (NSDictionary *fileInfo in fileArray) {
        if ([fileName isEqualToString:fileInfo[kFileName]]) {
            [fileArray removeObject:fileInfo];
            break;
        }
    }
    
    MAIN(^{
        [_tableView reloadData];
    });
}

- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)wifiUpload:(id)sender{
    EM_ChatWifiView *wifiView = [[EM_ChatWifiView alloc]initWithIPAdress:[NSString stringWithFormat:@"http://%@:%d",[self deviceIPAdress],self.httpServer.port]];
    [wifiView setAlertShowCompletedBlcok:^{
        if (self.httpServer.isRunning) {
            [self.httpServer stop:NO];
        }
        [self.httpServer start:nil];
    }];
    [wifiView setAlertDismissBlcok:^{
        if (self.httpServer.isRunning) {
            [self.httpServer stop:NO];
        }
    }];
    [wifiView show:UAlertPosition_Bottom offestY:0];
}

- (void)folderClicked:(UIButton *)sender{
    self.currentFolderIndex = sender.tag;
}

- (void)sendFileClicked:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(didFileSelected:)] && _selectedArray.count > 0) {
        [_delegate didFileSelected:_selectedArray];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *folderName = _folderArray[_currentFolderIndex][kFolderName];
    NSArray *fileArray = _fileDictionary[folderName];
    if (!fileArray) {
        fileArray = [[NSMutableArray alloc]initWithArray:[EM_ChatFileUtils filesInfoWithType:folderName]];
        [_fileDictionary setObject:fileArray forKey:folderName];
    }
    return fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *folderName = _folderArray[_currentFolderIndex][kFolderName];
    
    EM_ExplorerBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:folderName];
    if (!cell) {
        cell = [[EM_ExplorerBaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:folderName];
    }
    
    NSArray *fileArray = _fileDictionary[folderName];
    NSDictionary *fileInfo = fileArray[indexPath.row];
    cell.selectedItem = [_selectedArray containsObject:fileInfo[kFilePath]];
    cell.fileInfo = fileInfo;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *folder = _folderArray[_currentFolderIndex];
    NSArray *fileArray = _fileDictionary[folder[kFolderName]];
    NSDictionary *fileInfo = fileArray[indexPath.row];
    
    NSString *filePath = fileInfo[kFilePath];
    if ([_selectedArray containsObject:filePath]) {
        [_selectedArray removeObject:filePath];
    }else{
        [_selectedArray addObject:filePath];
    }
    
    _enterButton.enabled = _selectedArray.count > 0;
    if (_enterButton.enabled) {
        [_enterButton setTitle:[NSString stringWithFormat:@"%@(%ld)",[EM_ChatResourcesUtils stringWithName:@"common.send"],_selectedArray.count] forState:UIControlStateNormal];
    }else{
        [_enterButton setTitle:[NSString stringWithFormat:@"%@",[EM_ChatResourcesUtils stringWithName:@"common.send"]] forState:UIControlStateNormal];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        NSDictionary *folder = _folderArray[_currentFolderIndex];
        NSMutableArray *fileArray = _fileDictionary[folder[kFolderName]];
        NSDictionary *fileInfo = fileArray[indexPath.row];
        NSString *filePath = fileInfo[kFilePath];
        
        if ([_selectedArray containsObject:filePath]) {
            [_selectedArray removeObject:filePath];
            
            _enterButton.enabled = _selectedArray.count > 0;
            if (_enterButton.enabled) {
                [_enterButton setTitle:[NSString stringWithFormat:@"%@(%ld)",[EM_ChatResourcesUtils stringWithName:@"common.send"],_selectedArray.count] forState:UIControlStateNormal];
            }else{
                [_enterButton setTitle:[NSString stringWithFormat:@"%@",[EM_ChatResourcesUtils stringWithName:@"common.send"]] forState:UIControlStateNormal];
            }
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [fileArray removeObject:fileInfo];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


@end