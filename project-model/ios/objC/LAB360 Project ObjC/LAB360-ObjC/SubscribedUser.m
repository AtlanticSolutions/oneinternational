//
//  SubscribedUser.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 17/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SubscribedUser.h"


#define CLASS_USER_DEFAULT @"app_subscribedUser"
#define CLASS_USER_KEY_NAME @"Nome"
#define CLASS_USER_KEY_LAST_NAME @"Sobrenome"
#define CLASS_USER_KEY_PHONE @"Telefone"
#define CLASS_USER_KEY_CPF @"CPF"
#define CLASS_USER_KEY_EMAIL @"Email"
#define CLASS_USER_KEY_CITY @"Cidade"
#define CLASS_USER_KEY_STATE @"Estado"
#define CLASS_USER_KEY_COUNTRY @"Pais"
#define CLASS_USER_KEY_CNPJ @"CPF_CNPJ"
#define CLASS_USER_KEY_COMPANY @"Empresa"
#define CLASS_USER_KEY_ZIPCODE @"CEP"
#define CLASS_USER_KEY_ADDRESS @"Endereco"
#define CLASS_USER_KEY_NUMBER @"Numero"
#define CLASS_USER_KEY_ROLE @"Cargo"
#define CLASS_USER_KEY_EVENTID @"CarrinhoCompras"
#define CLASS_USER_KEY_ADJUNCT @"Complemento"
#define CLASS_USER_KEY_HOMEPAGE @"HomePage"
#define CLASS_USER_KEY_NOTE @"Observacoes"

@implementation SubscribedUser

@synthesize eventID, name, email, lastName, phone, CPF, company, CNPJ, address, zipCode, city, country, state, role, adjunct, homePage, note, number;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        eventID = DOMP_OPD_INT;
        name = DOMP_OPD_STRING;
        email = DOMP_OPD_STRING;
        CPF = DOMP_OPD_STRING;
        homePage = DOMP_OPD_STRING;
        phone = DOMP_OPD_STRING;
        lastName = DOMP_OPD_STRING;
        zipCode = DOMP_OPD_STRING;
        city = DOMP_OPD_STRING;
        country = DOMP_OPD_STRING;
        state = DOMP_OPD_STRING;
        address = DOMP_OPD_STRING;
        CNPJ = DOMP_OPD_STRING;
        company = DOMP_OPD_STRING;
        role = DOMP_OPD_STRING;
        adjunct = DOMP_OPD_STRING;
        note = DOMP_OPD_STRING;
        number = DOMP_OPD_STRING;
        
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------
+(SubscribedUser*)newObject
{
    SubscribedUser *u = [SubscribedUser new];
    return u;
}

+(NSString*)className
{
    return CLASS_USER_DEFAULT;
}


+(SubscribedUser*)createObjectFromDictionary:(NSDictionary*)dicData
{
    SubscribedUser *u = [SubscribedUser new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    
    NSArray *keysList = [dicData allKeys];
    
    if (keysList.count > 0)
    {
        u.eventID = [keysList containsObject:CLASS_USER_KEY_EVENTID] ? [[dicData  valueForKey:CLASS_USER_KEY_EVENTID] intValue] : u.eventID;
        u.name = [keysList containsObject:CLASS_USER_KEY_NAME] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_NAME]] : u.name;
        u.lastName = [keysList containsObject:CLASS_USER_KEY_LAST_NAME] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_LAST_NAME]] : u.lastName;
        u.CPF = [keysList containsObject:CLASS_USER_KEY_CPF] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_CPF]] : u.CPF;
        u.phone = [keysList containsObject:CLASS_USER_KEY_PHONE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_PHONE]] : u.phone;
        u.email = [keysList containsObject:CLASS_USER_KEY_EMAIL] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_EMAIL]] : u.email;
        u.address = [keysList containsObject:CLASS_USER_KEY_ADDRESS] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_ADDRESS]] : u.address;
        u.city = [keysList containsObject:CLASS_USER_KEY_CITY] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_CITY]] : u.city;
        u.state = [keysList containsObject:CLASS_USER_KEY_STATE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_STATE]] : u.state;
        u.country = [keysList containsObject:CLASS_USER_KEY_COUNTRY] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_COUNTRY]] : u.country;
        u.company = [keysList containsObject:CLASS_USER_KEY_COMPANY] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_COMPANY]] : u.company;
        u.CNPJ = [keysList containsObject:CLASS_USER_KEY_CNPJ] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_CNPJ]] : u.CNPJ;
        u.zipCode = [keysList containsObject:CLASS_USER_KEY_ZIPCODE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_ZIPCODE]] : u.zipCode;
        u.role = [keysList containsObject:CLASS_USER_KEY_ROLE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_ROLE]] : u.role;
        u.homePage = [keysList containsObject:CLASS_USER_KEY_HOMEPAGE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_HOMEPAGE]] : u.homePage;
        u.number = [keysList containsObject:CLASS_USER_KEY_NUMBER] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_NUMBER]] : u.number;
        u.adjunct = [keysList containsObject:CLASS_USER_KEY_ADJUNCT] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_ADJUNCT]] : u.adjunct;
        u.note = [keysList containsObject:CLASS_USER_KEY_NOTE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_USER_KEY_NOTE]] : u.note;
        
        
    }
    
    return u;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:@(self.eventID) forKey:CLASS_USER_KEY_EVENTID];
    [dicData  setValue:self.name forKey:CLASS_USER_KEY_NAME];
    [dicData  setValue:self.lastName forKey:CLASS_USER_KEY_LAST_NAME];
    [dicData  setValue:self.number forKey:CLASS_USER_KEY_NUMBER];
    [dicData  setValue:self.email forKey:CLASS_USER_KEY_EMAIL];
    [dicData  setValue:self.CPF forKey:CLASS_USER_KEY_CPF];
    [dicData  setValue:self.phone forKey:CLASS_USER_KEY_PHONE];
    [dicData  setValue:self.company forKeyPath:CLASS_USER_KEY_COMPANY];
    [dicData  setValue:self.CNPJ forKey:CLASS_USER_KEY_CNPJ];
    [dicData  setValue:self.role forKey:CLASS_USER_KEY_ROLE];
    [dicData  setValue:self.address forKey:CLASS_USER_KEY_ADDRESS];
    [dicData  setValue:self.zipCode forKey:CLASS_USER_KEY_ZIPCODE];
    [dicData  setValue:self.city forKey:CLASS_USER_KEY_CITY];
    [dicData  setValue:self.state forKey:CLASS_USER_KEY_STATE];
    [dicData  setValue:self.country forKey:CLASS_USER_KEY_COUNTRY];
    [dicData  setValue:self.note forKey:CLASS_USER_KEY_NOTE];
    [dicData  setValue:self.adjunct forKey:CLASS_USER_KEY_ADJUNCT];
    [dicData  setValue:self.homePage forKey:CLASS_USER_KEY_HOMEPAGE];
   
    return dicData;
}

- (SubscribedUser *) copyObject
{
    
    SubscribedUser *u = [SubscribedUser new];
    u.eventID = self.eventID;
    u.name = [NSString stringWithFormat:@"%@", self.name];
    u.lastName = [NSString stringWithFormat:@"%@", self.lastName];
    u.CPF = [NSString stringWithFormat:@"%@", self.CPF];
    u.country = [NSString stringWithFormat:@"%@", self.country];;
    u.state = [NSString stringWithFormat:@"%@", self.state];
    u.company = [NSString stringWithFormat:@"%@", self.company];
    u.city = [NSString stringWithFormat:@"%@", self.city];
    u.zipCode = [NSString stringWithFormat:@"%@", self.zipCode];
    u.email = [NSString stringWithFormat:@"%@", self.email];
    u.CNPJ = [NSString stringWithFormat:@"%@", self.CNPJ];
    u.role = [NSString stringWithFormat:@"%@", self.role];
    u.address = [NSString stringWithFormat:@"%@", self.address];
    u.number = [NSString stringWithFormat:@"%@", self.number];
    u.phone = [NSString stringWithFormat:@"%@", self.phone];
    u.note = [NSString stringWithFormat:@"%@", self.note];
    u.adjunct = [NSString stringWithFormat:@"%@", self.adjunct];
    u.homePage = [NSString stringWithFormat:@"%@", self.homePage];
    
    return u;
}


@end
