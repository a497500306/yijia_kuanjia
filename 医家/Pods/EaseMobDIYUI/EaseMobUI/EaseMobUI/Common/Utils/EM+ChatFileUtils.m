//
//  EM+ChatFileUtils.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/6.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatFileUtils.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+Common.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation EM_ChatFileUtils

NSString * const kFolderTitle = @"kFolderTitle";
NSString * const kFolderName = @"kFolderName";
NSString * const kFolderPath = @"kFolderPath";
NSString * const kFolderContent = @"kFolderContent";

NSString * const kFileName = @"kFileName";
NSString * const kFilePath = @"kFilePath";
NSString * const kFileType = @"kFileType";
NSString * const kFileAttributes = @"kFileAttributes";

NSString * const kFileState = @"kFileState";
NSString * const kFileSize = @"kFileSize";

NSString * const kFileUploadStart = @"kFileUploadStart";
NSString * const kFileUploadProcess = @"kFileUploadProcess";
NSString * const kFileUploadComplete = @"kFileUploadComplete";


+ (BOOL)initialize{
    BOOL create = [self createFolderWithPath:kChatFolderPath];
    if (!create) {
        NSLog(@"创建根目录失败");
        return NO;
    }else{
        NSLog(@"创建根目录 - %@",kChatFolderPath);
    }
    
    create = [self createFolderWithPath:kChatDBFolderPath];
    if (!create) {
        NSLog(@"创建数据库目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileFolderPath];
    if (!create) {
        NSLog(@"创建文件目录失败");
        return NO;
    }
    
    create = [self createFolderWithPath:kChatFileDocumentFolderPath];
    if (!create) {
        NSLog(@"创建文档目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileVideoFolderPath];
    if (!create) {
        NSLog(@"创建视频目录失败");
    }
    create = [self createFolderWithPath:[NSString stringWithFormat:@"%@Thumb",kChatFileVideoFolderPath]];
    if (!create) {
        NSLog(@"创建视频缩略图目录失败");
    }
    
    
    create = [self createFolderWithPath:kChatFileImageFolderPath];
    if (!create) {
        NSLog(@"创建图片目录失败");
    }
    create = [self createFolderWithPath:[NSString stringWithFormat:@"%@Thumb",kChatFileImageFolderPath]];
    if (!create) {
        NSLog(@"创建图片缩略图目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileAudioFolderPath];
    if (!create) {
        NSLog(@"创建音频目录失败");
    }
    create = [self createFolderWithPath:[NSString stringWithFormat:@"%@Thumb",kChatFileAudioFolderPath]];
    if (!create) {
        NSLog(@"创建音频缩略图目录失败");
    }
    
    
    create = [self createFolderWithPath:kChatFileOtherFolderPath];
    if (!create) {
        NSLog(@"创建其他目录失败");
    }
    
    return YES;
}

+ (BOOL)createFolderWithPath:path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExisted = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    BOOL isCreated = isDir && isExisted;
    if (!isCreated){
        isCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return isCreated;
}

+ (NSArray *)folderArray{
    static NSMutableArray *_folderArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _folderArray = [[NSMutableArray alloc] init];

        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.image"],
                                  kFolderName : kChatFileImageFolderName,
                                  kFolderPath : kChatFileImageFolderPath}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.audio"],
                                  kFolderName : kChatFileAudioFolderName,
                                  kFolderPath : kChatFileAudioFolderPath}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.video"],
                                  kFolderName : kChatFileVideoFolderName,
                                  kFolderPath : kChatFileVideoFolderPath}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.document"],
                                  kFolderName : kChatFileDocumentFolderName,
                                  kFolderPath : kChatFileDocumentFolderPath}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.other"],
                                  kFolderName : kChatFileOtherFolderName,
                                  kFolderPath : kChatFileOtherFolderPath}];
    });
    return _folderArray;
}

+ (NSArray *)filesInfoAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsAtPath:path];
    NSMutableArray *filesInfo = [[NSMutableArray alloc]init];
    
    for (NSString *fileName in files) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
        NSMutableDictionary *fileInfo = [[NSMutableDictionary alloc]init];
        [fileInfo setObject:fileName forKey:kFileName];
        [fileInfo setObject:filePath forKey:kFilePath];
        [fileInfo setObject:[path lastPathComponent] forKey:kFileType];
        [fileInfo setObject:@([attributes fileSize]) forKey:kFileSize];
        [fileInfo setObject:kFileUploadComplete forKey:kFileState];
        [fileInfo setObject:attributes forKey:kFileAttributes];
        [filesInfo addObject:fileInfo];
    }
    
    [filesInfo sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *fileModify1 = [[obj1 objectForKey:kFileAttributes] fileModificationDate];
        NSDate *fileModify2 = [[obj2 objectForKey:kFileAttributes] fileModificationDate];
        
        if (fileModify1.timeIntervalSince1970 > fileModify2.timeIntervalSince1970) {
            return NSOrderedAscending;
        }else if (fileModify1.timeIntervalSince1970 < fileModify2.timeIntervalSince1970){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    return filesInfo;
}

+ (NSArray *)filesInfoWithType:(NSString *)type{
    return [self filesInfoAtPath:[NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,type]];
}

+ (long long)fileSizeAtPath:(NSString *)path{
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
}

+ (NSString *)stringFileSizeAtPath:(NSString *)path{
    long long fileSize = [self fileSizeAtPath:path];
    return  [self stringFileSize:fileSize];
}

+ (NSString *)stringFileSize:(long long)fileSize{
    if (fileSize > 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%0.2fG",fileSize / (1024.0 * 1024.0 * 1024.0)];
    }else if(fileSize > 1024 * 1024){
        return [NSString stringWithFormat:@"%0.2fM",fileSize / (1024.0 * 1024.0)];
    }else if (fileSize > 1024){
        return [NSString stringWithFormat:@"%0.2fK",fileSize / 1024.0];
    }else{
        return [NSString stringWithFormat:@"%lldB",fileSize];
    }
}

+ (UIImage *)thumbImageFromOriginalImage:(UIImage *)image width:(float)width height:(float)height{
    if (!image) {
        return nil;
    }
    CGSize size = CGSizeMake(width, height);
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(60, 60);
    }

    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumb;
}

+ (UIImage *)thumbImageWithURL:(NSURL *)url{
    NSString *path = url.path;
    NSString *imageName = [path lastPathComponent];
    NSString *imageDirectory = [path substringToIndex:[path rangeOfString:imageName].location - 1];
    NSString *thumbPath = [NSString stringWithFormat:@"%@Thumb/%@",imageDirectory,imageName];
    
    BOOL isDirectory;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:thumbPath isDirectory:&isDirectory];
    BOOL isCreated = isExists && !isDirectory;
    
    if (isCreated) {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:thumbPath]];
    }else{
        UIImage *thumbImage = [self thumbImageFromOriginalImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]] width:80 height:80];
        if (thumbImage) {
            BACK(^{
                BOOL created = [[NSFileManager defaultManager] createFileAtPath:thumbPath contents:nil attributes:nil];
                if (created) {
                    [UIImageJPEGRepresentation(thumbImage, 1.0) writeToFile:thumbPath atomically:YES];
                }
            });
            return thumbImage;
        }else{
            return [EM_ChatResourcesUtils fileImageWithName:@"image"];
        }
    }
}

+ (UIImage *)thumbAudioWithURL:(NSURL *)url{
    NSString *path = url.path;
    NSString *audioName = [path lastPathComponent];
    NSString *audioDirectory = [path substringToIndex:[path rangeOfString:audioName].location - 1];
    NSString *thumbPath = [NSString stringWithFormat:@"%@Thumb/%@",audioDirectory,audioName];
    
    BOOL isDirectory;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:thumbPath isDirectory:&isDirectory];
    BOOL isCreated = isExists && !isDirectory;
    
    if (isCreated) {
        return [UIImage imageWithContentsOfFile:thumbPath];
    }else{
        NSData *data = nil;
        AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        for (NSString *format in [audioAsset availableMetadataFormats]) {
            for (AVMetadataItem *metadataItem in [audioAsset metadataForFormat:format]) {
                if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                    data = (NSData *)metadataItem.value;
                    break;
                }
            }
            if (data) {
                break;
            }
        }
        if (data) {
            BACK(^{
                BOOL created = [[NSFileManager defaultManager] createFileAtPath:thumbPath contents:nil attributes:nil];
                if (created) {
                    [data writeToFile:thumbPath atomically:YES];
                }
            });
            return [UIImage imageWithData:data];
        }else{
            return [EM_ChatResourcesUtils fileImageWithName:@"audio"];
        }
    }
}

+ (UIImage *)thumbVideoWithURL:(NSURL *)url{
    NSString *path = url.path;
    NSString *videoName = [path lastPathComponent];
    NSString *videoDirectory = [path substringToIndex:[path rangeOfString:videoName].location - 1];
    NSString *thumbPath = [NSString stringWithFormat:@"%@Thumb/%@",videoDirectory,videoName];
    
    BOOL isDirectory;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:thumbPath isDirectory:&isDirectory];
    BOOL isCreated = isExists && !isDirectory;
    if (isCreated) {
        return [UIImage imageWithContentsOfFile:thumbPath];
    }else{
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = CGSizeMake(600, 450);
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10000) actualTime:NULL error:&error];
        UIImage *image = [UIImage imageWithCGImage: img];
        
        if (image) {
            BACK(^{
                BOOL created = [[NSFileManager defaultManager] createFileAtPath:thumbPath contents:nil attributes:nil];
                if (created) {
                    [UIImageJPEGRepresentation(image, 1.0) writeToFile:thumbPath atomically:YES];
                }
            });
            
            return image;
        }else{
            return [EM_ChatResourcesUtils fileImageWithName:@"video"];
        }
    }
}

@end