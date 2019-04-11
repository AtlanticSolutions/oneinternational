//
//  ZipDownloader.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZipDownloader : NSObject

/**
 @brief     Faz o download de um arquivo zip, podendo descompactá-lo imediatamente após o recebimento do mesmo.
 @param     fileURL     Endereço (remoto) do arquivo a ser baixado.
 @param     destinyFolderPath       Caminho da pasta para onde o arquivo deve ser baixado.
 @param     fileName       Nome do arquivo, sem extensão.
 @param     unzipFile       Determina se o arquivo será descompactado imediatamente após o download ou não.
 @param     deleteOriginal      Quando o arquivo for descompatado é possível indicar que o mesmo deve ser deletado após o processo.
 @param     progressHandler     Indica o progresso do download.
 @param     completionHandler       Bloco que será chamado ao final da operação, tendo ela finalizado com sucesso ou não.
 @note     O arquivo zip vazio (sem arquivos internos após a descompactação) será considerado um erro. Caso o arquivo já exista na pasta destino ele será sobrescrito.
 */
- (void)downloadZipFileFrom:(NSString* _Nonnull)fileURL toFolderPath:(NSString* _Nonnull)destinyFolderPath fileName:(NSString*)fileName unzipping:(BOOL)unzipFile deletingOriginalFile:(BOOL)deleteOriginal usingProgressHandler:(void (^_Nullable)(float progress))progressHandler andCompletionHandler:(void (^_Nullable)(BOOL success, NSError* _Nullable error)) completionHandler;

@end
