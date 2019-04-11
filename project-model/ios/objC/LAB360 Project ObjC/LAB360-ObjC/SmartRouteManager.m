//
//  SmartRouteManager.m
//  Siga
//
//  Created by Erico GT on 27/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "SmartRouteManager.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "ToolBox.h"
#import "AsyncImageDownloader.h"

@interface SmartRouteManager()<CLLocationManagerDelegate>

//Properties
@property (nonatomic, strong) SmartRouteInterestPoint *lastPoint;
@property (nonatomic, strong) NSMutableArray *bannersList;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL requestingData;
@property (nonatomic, assign) BOOL processingData;

@end

@implementation SmartRouteManager

@synthesize delegate, lastUpdate;
@synthesize lastPoint, bannersList, locationManager, requestingData, processingData, timeBetweenBanners;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        delegate = nil;
        bannersList = [NSMutableArray new];
        locationManager = nil;
        requestingData = NO;
        processingData = NO;
        timeBetweenBanners = 5.0;
    }
    return self;
}

#pragma mark -

- (void) startUpdatingUserLocation
{
    BOOL needStart = NO;
    for (SmartRouteInterestPoint *point in bannersList){
        if (point.pointsList.count > 0){
            needStart = YES;
            break;
        }
    }
    
    if (needStart){
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
            [self.locationManager setAllowsBackgroundLocationUpdates:NO]; //YES para background-mode
            [self.locationManager setPausesLocationUpdatesAutomatically:NO];
            if (@available(iOS 11.0, *)) {
                [self.locationManager setShowsBackgroundLocationIndicator:NO];
            }
            self.locationManager.delegate = self;
        }
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusAuthorizedWhenInUse){
            [self.locationManager requestAlwaysAuthorization];
        }else{
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void) stopUpdatingUserLocation
{
    [self.locationManager stopUpdatingLocation];
    //
    lastPoint = nil;
    //
    if (delegate){
        [delegate smartRouteManager:self didUpdateCurrentInterestPoint:lastPoint];
    }
}

- (NSArray<SmartRouteInterestPoint*>* _Nonnull) getBannersList
{
    if (bannersList == nil || bannersList.count == 0){
        return [NSArray new];
    }else{
        NSMutableArray *list = [NSMutableArray new];
        for (SmartRouteInterestPoint *point in bannersList){
            [list addObject:[point copyReducedObject]];
        }
        return list;
    }
}

- (void)processLastPoint
{
    processingData = YES;
    
    if (lastPoint.bannerImage != nil){
        //A imagem do banner já foi baixada anteriormente:
        if (delegate){
            [delegate smartRouteManager:self didUpdateCurrentInterestPoint:lastPoint];
            processingData = NO;
        }
    }else{
        //É preciso baixar a imagem do banner:
        [[[AsyncImageDownloader alloc] initWithFileURL:lastPoint.bannerURL successBlock:^(NSData *data) {
            
            if (data){
                lastPoint.bannerImage = [UIImage imageWithData:data];
            }
            
            if (delegate){
                [delegate smartRouteManager:self didUpdateCurrentInterestPoint:lastPoint];
                processingData = NO;
            }
            
        } failBlock:^(NSError *error) {
            NSLog(@"Erro ao buscar imagem: %@", error.domain);
            
            if (delegate){
                [delegate smartRouteManager:self didUpdateCurrentInterestPoint:lastPoint];
                processingData = NO;
            }
            
        }] startDownload];
    }
}

- (void) updateBannersFromServerWithCompletionHandler:(void (^_Nullable)(DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        requestingData = YES;
        
        //NSMutableDictionary *parameters = [NSMutableDictionary new];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_BANNERS_GEOFENCE_TIMELINE];
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(response);
                //
                requestingData = NO;
            }else{
                
                lastUpdate = [NSDate date];
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        NSString *keyName = @"banners";
                    
                        //Exemplo:
                //{
                //    "custom_banners": [
                //                       {
                //                           "id": 1,
                //                           "name": "Região Rodovia 1",
                //                           "url_image": "www.urlimage.com.br",
                //                           "phone_number" : "(11)1234-5678",
                //                           "message" : "Utilize este número para pedir ajuda, etc, etc...",
                //                           "locations": [
                //                           {
                //                               "id" : 1,
                //                               "latitude" : "-23.5019783",
                //                               "longitude" : "-46.8464165",
                //                               "radius" : 100.0
                //                           },
                //                           {
                //                               "id" : 2,
                //                               "latitude" : "-23.5019783",
                //                               "longitude" : "-46.8464165",
                //                               "radius" : 100.0
                //                           }
                //                                         ]
                //                       }
                //                       ]
                //}
                        
                        if ([[dicResponse allKeys] containsObject:keyName]) {

                            bannersList = [NSMutableArray new];
                            if ([[dicResponse valueForKey:keyName] isKindOfClass:[NSDictionary class]]){
                                SmartRouteInterestPoint *ip = [SmartRouteInterestPoint createObjectFromDictionary:[dicResponse valueForKey:keyName]];
                                [bannersList addObject:ip];
                            }else if ([[dicResponse valueForKey:keyName] isKindOfClass:[NSArray class]]){
                                NSArray *list = [dicResponse valueForKey:keyName];
                                for (NSDictionary *dic in list){
                                    SmartRouteInterestPoint *ip = [SmartRouteInterestPoint createObjectFromDictionary:dic];
                                    [bannersList addObject:ip];
                                }
                            }

                            if (bannersList.count > 0){
                                
                                if ([[dicResponse allKeys] containsObject:@"time"]) {
                                    int seconds = [[dicResponse valueForKey:@"time"] intValue];
                                    if (seconds > 0){
                                        timeBetweenBanners = seconds;
                                    }
                                }
                                
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                                handler(response);
                            }else{
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                                handler(response);
                            }

                        }else{
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                            handler(response);
                        }
                        
                        
                        //Mock: ************************************************************************************************************************************
                        
//                        bannersList = [NSMutableArray new];
//
//                        SmartRouteInterestPoint *point1 = [SmartRouteInterestPoint new];
//                        point1.pointID = 1;
//                        point1.name = @"Banner 1";
//                        point1.bannerURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/siga/resources/CUSTOM_BANNER_1.jpg";
//                        point1.bannerImage = nil;
//                        point1.phoneNumber = @"(15)98119-5877";
//                        point1.message = @"Mensagem para o banner 1.\nBlá, b;á, blá...";
//                        point1.pointsList = [NSMutableArray new];
//                        //
//                        ImprovedCircularRegion *r1 = [[ImprovedCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(-23.498814, -46.847993) radius:100.0 identifier:@"R1"];
//                        r1.regionID = 1;
//                        [point1.pointsList addObject:r1];
//                        //
//                        ImprovedCircularRegion *r2 = [[ImprovedCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(-23.492102, -46.845060) radius:100.0 identifier:@"R2"];
//                        r2.regionID = 2;
//                        [point1.pointsList addObject:r2];
//
//                        SmartRouteInterestPoint *point2 = [SmartRouteInterestPoint new];
//                        point2.pointID = 1;
//                        point2.name = @"Banner 2";
//                        point2.bannerURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/siga/resources/CUSTOM_BANNER_2.jpg";
//                        point2.bannerImage = nil;
//                        point2.phoneNumber = @"(15)98119-5877";
//                        point2.message = @"Mensagem para o banner 2.\nBlá, b;á, blá...";
//                        point2.pointsList = [NSMutableArray new];
//                        //
//                        ImprovedCircularRegion *r3 = [[ImprovedCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(-23.495840, -46.853676) radius:100.0 identifier:@"R3"];
//                        r3.regionID = 3;
//                        [point2.pointsList addObject:r1];
//
//                        [bannersList addObject:point1];
//                        [bannersList addObject:point2];
//
//                        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
//                        handler(response);
                        
                        //**********************************************************************************************************************************************************

                        requestingData = NO;
                        
                    }else{
                        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                        handler(response);
                    }
                }else{
                    DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                    handler(response);
                }
            }
            
        }];
        
    }else{
        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNoConnection errorIdentifier:nil] error:DataSourceResponseErrorTypeNoConnection];
        handler(response);
    }
}

#pragma mark - DELEGATE

- (NSString*_Nonnull)errorMessageForType:(DataSourceResponseErrorType)type errorIdentifier:(NSString*_Nullable)identifier
{
    switch (type) {
            
            //Quando a operação não encontrou erro algum.
        case DataSourceResponseErrorTypeNone:{
            return @"Dados recuperados com sucesso!";
        }break;
            
            //Os dados precisam de internet para serem resgatados mas não há conexão disponível.
        case DataSourceResponseErrorTypeNoConnection:{
            return @"Ops...\n\nParece que não há nenhuma conexão disponível no momento.\n\nVerifique sua internet e tente novamente!";
        }break;
            
            //Ocorreu um erro na conexão que impede o resgate dos dados.
        case DataSourceResponseErrorTypeConnectionError:{
            return @"Um problema na conexão impede que os dados sejam carregados no momento. Por favor, tente mais tarde.";
        }break;
            
            //Os dados encontrados não correspondem aos esperados (por tipo, qtd, formato, etc).
        case DataSourceResponseErrorTypeInvalidData:{
            return @"Nenhum dado válido foi encontrado!";
        }break;
            
            //Ocorreu um erro interno no processamento dos dados (parse por exemplo). Por padrão o 'identifier' já deve ser a descrição da exceção.
        case DataSourceResponseErrorTypeInternalException:{
            return (identifier == nil ? @"Erro desconhecido!" : identifier);
        }break;
            
            //Erro genérico, não categorizado.
        case DataSourceResponseErrorTypeGeneric:{
            return @"Não foi possível carregar os dados no momento. Por favor, tente mais tarde.";
        }break;
    }
}

#pragma mark - Location Manager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (requestingData == NO && processingData == NO){
        
        CLLocation *location = [locations lastObject];
        
        BOOL finded = NO;
        
        for (SmartRouteInterestPoint *point in self.bannersList){
            
            for (ImprovedCircularRegion *region in point.pointsList){
                
                if ([region containsCoordinate:location.coordinate]){
                    
                    BOOL needProcess = NO;
                    
                    //Encontrou uma área de interesse:
                    if (lastPoint == nil){
                        lastPoint = [point copyReducedObject];
                        lastPoint.pointsList = nil;
                        //
                        needProcess = YES;
                    }else{
                        if (point.pointID != lastPoint.pointID){
                            lastPoint = [point copyReducedObject];
                            lastPoint.pointsList = nil;
                            //
                            needProcess = YES;
                        }
                    }
                    
                    if (needProcess){
                        
                        [self processLastPoint];
                    }
                    
                    finded = YES;
                    break;
                }
            }
            
            if (finded){
                break;
            }
        }
        
        if (!finded){
            //Precisa avisar que saiu de todas as áreas rastreadas:
            lastPoint = nil;
            if (delegate){
                [delegate smartRouteManager:self didUpdateCurrentInterestPoint:lastPoint];
            }
        }
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    lastPoint = nil;
    if (delegate){
        [delegate smartRouteManager:self didUpdateCurrentInterestPoint:lastPoint];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager startUpdatingLocation];
    }
}

@end
