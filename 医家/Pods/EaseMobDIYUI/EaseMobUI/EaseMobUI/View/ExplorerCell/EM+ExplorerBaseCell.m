//
//  EM+ExplorerBaseCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ExplorerBaseCell.h"
#import "EM+ChatDateUtils.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatResourcesUtils.h"

#import "EM+Common.h"
#import "UIColor+Hex.h"

@implementation EM_ExplorerBaseCell{
    UIView *bottomLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.separatorInset = UIEdgeInsetsMake(2, 0, 2, 0);
        
        bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:bottomLine];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    bottomLine.frame = CGRectMake(0, size.height - LINE_HEIGHT, size.width, LINE_HEIGHT);
}

- (void)setSelectedItem:(BOOL)selectedItem{
    _selectedItem = selectedItem;
    if (_selectedItem) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setFileInfo:(NSDictionary *)fileInfo{
    _fileInfo = fileInfo;
    self.textLabel.text = _fileInfo[kFileName];
    
    NSString *state = _fileInfo[kFileState];
    _upload = ![state isEqualToString:kFileUploadComplete];
    
    NSDictionary *attributes = _fileInfo[kFileAttributes];
    long long uploadSize = [attributes fileSize];
    
    if (_upload) {
        long long fileSize = [_fileInfo[kFileSize] longLongValue];
        NSString *progress = [NSString stringWithFormat:@"上传中%0.2f%@",((double)uploadSize) / ((double)fileSize) * 100,@"%"];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@\n%@",[EM_ChatFileUtils stringFileSize:uploadSize],[EM_ChatFileUtils stringFileSize:fileSize],progress];
    }else{
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",[EM_ChatFileUtils stringFileSize:uploadSize],[EM_ChatDateUtils dateConvertToString:[attributes fileModificationDate] formatter:@"yyyy-MM-dd HH:mm"]];
    }
    
    NSString *fileType = _fileInfo[kFileType];
    NSString *filePath = _fileInfo[kFilePath];
    
    if (_upload) {
        self.imageView.image = [EM_ChatResourcesUtils fileImageWithName:fileType];
    }else{
        if ([fileType isEqualToString:kChatFileImageFolderName]) {
            self.imageView.image = [EM_ChatFileUtils thumbImageWithURL:[NSURL fileURLWithPath:filePath]];
        }else if([fileType isEqualToString:kChatFileAudioFolderName]){
            self.imageView.image = [EM_ChatFileUtils thumbAudioWithURL:[NSURL fileURLWithPath:filePath]];
        }else if([fileType isEqualToString:kChatFileVideoFolderName]){
            self.imageView.image = [EM_ChatFileUtils thumbVideoWithURL:[NSURL fileURLWithPath:filePath]];
        }else{
            self.imageView.image = [EM_ChatResourcesUtils fileImageWithName:fileType];
        }
    }
}

@end