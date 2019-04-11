//
//  ActionModel3D_AR_DataManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 24/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "ActionModel3D_AR_DataManager.h"
#import "ToolBox.h"

#define ACTIONMODEL3D_DATAMANAGER_CACHEMAXAGE 12

@interface ActionModel3D_AR_DataManager()

@property(nonatomic, strong) NSMutableArray<ActionModel3D_AR*>* cachedActions;

@end

@implementation ActionModel3D_AR_DataManager

@synthesize cachedActions;

- (instancetype)init
{
    self = [super init];
    if (self) {
        cachedActions = [NSMutableArray new];
    }
    return self;
}

#pragma mark - singleton method

+ (ActionModel3D_AR_DataManager*)sharedInstance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (BOOL)saveActionModel3D:(ActionModel3D_AR*)model
{
    if (model != nil){
        
        //NEVER
        if (model.cachePolicy == ActionModel3DDataCachePolicyNever){
            return NO;
        }
        
        //SESSION
        if (model.cachePolicy == ActionModel3DDataCachePolicySession){
            [self.cachedActions addObject:[model copyObject]];
            return YES;
        }
        
        //LIMITED / PERMANENT
        model.cacheDate = [NSDate date];
        
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
        
        NSString *mainFolder = @"ActionModel3D";
        NSString *objName = [NSString stringWithFormat:@"obj%li.model", model.actionID];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
        NSString *mainPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", mainFolder]];
        
        //Controle de diretórios ******************************************************************************************************
        
        if (![self directoryExists:mainPath])
        {
            if (![self createDirectoryAtPath:mainPath]) {
                return NO;
            }
        }
        
        NSString *objFile = [mainPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objName]];
        
        if (![self fileExists:objFile])
        {
            if (![self createFileAtPath:objFile])
            {
                return NO;
            }
        }
        
        return [modelData writeToFile:objFile atomically:YES];
        
    }else{
        return NO;
    }
}

- (ActionModel3D_AR*)loadResourcesFromDiskUsingReference:(ActionModel3D_AR*)model
{
    long identifier = model.objSet.objID != 0 ? model.objSet.objID : model.actionID;
    //Carregando dados de audio:
    if (model.sceneSet.localAudioFileURL == nil){
        model.sceneSet.localAudioFileURL = [self audioFileLocalURLforID:identifier];
    }
    
    ActionModel3D_AR *cachedObject = nil;
    
    //NEVER
    if (model.cachePolicy == ActionModel3DDataCachePolicyNever){
        return model;
    }
    
    //SESSION
    if (model.cachePolicy == ActionModel3DDataCachePolicySession){
        for (ActionModel3D_AR *obj in self.cachedActions){
            if (obj.actionID == model.actionID){
                cachedObject = obj;
                break;
            }
        }
    }
    
    //LIMITED / PERMANENT
    if (model.cachePolicy == ActionModel3DDataCachePolicyLimited || model.cachePolicy == ActionModel3DDataCachePolicyPermanent){
        
        NSString *mainFolder = @"ActionModel3D";
        NSString *objName = [NSString stringWithFormat:@"obj%li.model", model.actionID];
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
        NSString *mainPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", mainFolder]];
        NSString *objFile = [mainPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objName]];
        
        if (![self fileExists:objFile]){
            return model;
        }
        
        NSData *modelData = [NSData dataWithContentsOfFile:objFile];
        
        if (modelData == nil){
            return model;
        }
        
        cachedObject = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
    }
    
    if (cachedObject){
        
        //Limpando o histórico (no caso de divergência de tipos):
        if (cachedObject.cachePolicy != model.cachePolicy){
            [self clearCacheForActionModel:cachedObject];
        }
        
        //Verificação de tempo de cache:
        if (model.cachePolicy == ActionModel3DDataCachePolicyLimited){
            
            if ([ToolBox dateHelper_CalculateTotalHoursBetweenInitialDate:cachedObject.cacheDate andFinalDate:[NSDate date]] > ACTIONMODEL3D_DATAMANAGER_CACHEMAXAGE){
                [self clearCacheForActionModel:cachedObject];
                //
                return model;
            }
        }
        
        //NOTE: Se o modelo já existe salvo localmente seus recursos são utilizados:
        
        //Background Image
        if (cachedObject.sceneSet.backgroundImage != nil){
            if ([cachedObject.sceneSet.backgroundURL isEqualToString:model.sceneSet.backgroundURL]){
                model.sceneSet.backgroundImage = [UIImage imageWithData:UIImagePNGRepresentation(cachedObject.sceneSet.backgroundImage)];
            }else{
                model.sceneSet.backgroundImage = nil;
            }
        }
        
        //Target Image:
        if (cachedObject.targetImageSet.image != nil){
            if ([cachedObject.targetImageSet.imageURL isEqualToString:model.targetImageSet.imageURL]){
                model.targetImageSet.image = [UIImage imageWithData:UIImagePNGRepresentation(cachedObject.targetImageSet.image)];
            }else{
                model.targetImageSet.image = nil;
            }
        }
        
        //Carregando dados do OBJ:
        if (model.objSet.objLocalURL == nil){
            model.objSet.objLocalURL = [self objFileLocalURLforID:identifier andActionType:model.type];
        }
        
        return model;
    }else{
        
        //Carregando dados do OBJ. NOTE: Mesmo sem existir o objeto no cache ainda sim pode haver o arquivo zip do OBJ.
        if (model.objSet.objLocalURL == nil){
            model.objSet.objLocalURL = [self objFileLocalURLforID:identifier andActionType:model.type];
        }
        
        return model;
    }
    
}

- (void)clearCacheForActionModel:(ActionModel3D_AR*)action
{
    //clear memory:
    ActionModel3D_AR *actionToDelete = nil;
    for (ActionModel3D_AR *obj in self.cachedActions){
        if (action.actionID == obj.actionID){
            actionToDelete = obj;
            break;
        }
    }
    if (actionToDelete){
        [self.cachedActions removeObject:actionToDelete];
    }
    
    
    //clear disk:
    NSString *mainFolder = @"ActionModel3D";
    NSString *objName = [NSString stringWithFormat:@"obj%li.model", action.actionID];
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *mainPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", mainFolder]];
    NSString *objFile = [mainPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objName]];
    [self deleteFileAtPath:objFile];
    
    
    //clear OBJ file:
    long identifier = action.objSet.objID != 0 ? action.objSet.objID : action.actionID;
    //model3D
    if (action.objSet.objLocalURL){
        [self deleteFileAtPath:action.objSet.objLocalURL];
    }else{
        NSString *objFile = [self objFileLocalURLforID:identifier andActionType:action.type];
        [self deleteFileAtPath:objFile];
    }
    //audio
    if (action.sceneSet.localAudioFileURL){
        [self deleteFileAtPath:action.sceneSet.localAudioFileURL];
    }else{
        NSString *audioFile = [self audioFileLocalURLforID:identifier];
        [self deleteFileAtPath:audioFile];
    }
    //
    action.objSet.objLocalURL = nil;
    action.sceneSet.localAudioFileURL = nil;
}

- (NSString*)audioFileLocalURLforID:(long)identifier
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *mainFolder = @"objects3D";
    NSString *objFolder = [NSString stringWithFormat:@"obj%li", identifier];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *mainPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", mainFolder]];
    NSString *objPath = [mainPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objFolder]];
    
    NSError *error;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&error];
    if (directoryContents != nil){
        
        NSString *currentOBJ = nil;
        
        for (NSString *path in directoryContents){
            NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
            //
            if ([[fullPath lowercaseString] hasSuffix:@"mp3"]){
                currentOBJ = fullPath;
                break;
            }
        }
        
        return currentOBJ;
    }
    
    return nil;
}

- (NSString*)objFileLocalURLforID:(long)identifier andActionType:(ActionModel3DViewerType)actionType
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *mainFolder = @"objects3D";
    NSString *objFolder = [NSString stringWithFormat:@"obj%li", identifier];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *mainPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", mainFolder]];
    NSString *objPath = [mainPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objFolder]];
    
    NSError *error;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&error];
    if (directoryContents != nil){
        
        NSString *currentOBJ = nil;
        
        if (actionType == ActionModel3DViewerTypeAnimatedScene){
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                //
                if ([[fullPath lowercaseString] hasSuffix:@"scn"]){
                    if (currentOBJ == nil){
                        currentOBJ = [NSString stringWithFormat:@"%@", fullPath];
                    }else{
                        currentOBJ = [NSString stringWithFormat:@"%@ ; %@", currentOBJ, fullPath];
                    }
                }
            }
        }
        //USDZ
        else if (actionType == ActionModel3DViewerTypeQuickLookAR){
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                //
                if ([[fullPath lowercaseString] hasSuffix:@"usdz"]){
                    currentOBJ = fullPath;
                    break;
                }
            }
            
        }
        //OBJ
        else{
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                //
                if ([[fullPath lowercaseString] hasSuffix:@"obj"]){
                    currentOBJ = fullPath;
                    break;
                }
            }
        }
        
        return currentOBJ;
    }
    
    return nil;
}

#pragma mark - File Manipulation Methods

-(BOOL)directoryExists:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:directoryPath];
}

-(BOOL)fileExists:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

-(BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

-(BOOL)deleteFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager isDeletableFileAtPath:filePath]){
        NSError * err = NULL;
        if([fileManager removeItemAtPath:filePath error:&err]){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

@end
