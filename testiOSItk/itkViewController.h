//
//  itkViewController.h
//  testiOSItk
//
//  Created by ting xiao on 3/18/14.
//  Copyright (c) 2014 ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <iostream>
#include "itkiOSImageIO.h"
#include "ItkImage.h"
#include "itkImportImageFilter.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkRGBPixel.h"
#include "itkRGBAPixel.h"
#include "itkRescaleIntensityImageFilter.h"
#include "itkBinaryThresholdImageFilter.h"
#include "itkRGBToLuminanceImageFilter.h"

#include "itkPNGImageIO.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>




@interface itkViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *itkView;
@property(retain,nonatomic) UIImagePickerController *imagePicker;

-(IBAction)clickPicker:(id)sender;
-(IBAction)clickTry:(id)sender;
-(IBAction)clickFilter:(id)sender;

@end
