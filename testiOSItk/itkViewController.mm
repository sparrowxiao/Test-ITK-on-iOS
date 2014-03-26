//
//  itkViewController.m
//  testiOSItk
//
//  Created by ting xiao on 3/18/14.
//  Copyright (c) 2014 ting. All rights reserved.
//

#import "itkViewController.h"

using namespace std;

@interface itkViewController ()

@end

@implementation itkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //_itkView.image=nil;
    _itkView.image=[UIImage imageWithContentsOfFile:@"/Volumes/Learning/LiveInUGA/2014_spring/8850_ADV_BIO/testiOSItk/itkLogo.jpg"];
    _itkView.contentMode=UIViewContentModeScaleAspectFit;
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate =self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickPicker:(id)sender
{
 
    [self presentViewController:_imagePicker animated:YES completion:NULL];

}

/*
-(IBAction)clickTryTest:(id)sender
{
    typedef unsigned char ComponentType;
    typedef itk::Image< ComponentType, 2 > ImageType2D;
 
    
    
    const char * inputFilename  = "/Volumes/Learning/LiveInUGA/2014_spring/8850_ADV_BIO/testiOSItk/BrainProtonDensitySliceBorder20.png";
    
    const char * outputFilename  = "/Volumes/Learning/LiveInUGA/2014_spring/8850_ADV_BIO/testiOSItk/BrainProtonDensitySliceBorder_test.png";
    
    
    // Read in the image
    itk::PNGImageIO::Pointer io;
    io = itk::PNGImageIO::New();
    
    itk::ImageFileReader<ImageType2D>::Pointer reader;
    reader = itk::ImageFileReader<ImageType2D>::New();
    reader->SetFileName(inputFilename);
    reader->SetImageIO(io);
    reader->Update();
    
    
    //write to the new file
    itk::ImageFileWriter<ImageType2D>::Pointer writer;
    writer = itk::ImageFileWriter<ImageType2D>::New();
    writer->SetInput(reader->GetOutput());
    writer->SetFileName(outputFilename);
    writer->SetImageIO(io);
    writer->Write();
 

}*/


-(IBAction)clickTry:(id)sender
{
    typedef itk::RGBAPixel<unsigned int> RGBAPixelType;
	typedef unsigned char GrayscalePixelType;
	typedef itk::Image< RGBAPixelType, 2 > RGBAImageType;
	typedef itk::Image< GrayscalePixelType, 2 > GrayscaleImageType;
	typedef itk::ImageFileReader< RGBAImageType > RGBAReaderType;
    typedef itk::ImageFileWriter<RGBAImageType> RGBAWriterType;
	typedef itk::ImageFileReader< GrayscaleImageType > GrayscaleReaderType;
	typedef itk::ImageFileWriter< GrayscaleImageType > GrayscaleWriterType;
	
	RGBAReaderType::Pointer  RGBAReader = RGBAReaderType::New();
    RGBAWriterType::Pointer  RGBAWriter = RGBAWriterType::New();
	GrayscaleReaderType::Pointer  grayReader = GrayscaleReaderType::New();
	GrayscaleWriterType::Pointer  grayWriter = GrayscaleWriterType::New();
	
	
	itk::itkiOSImageIO::Pointer imageIO1 = itk::itkiOSImageIO::New();
	itk::itkiOSImageIO::Pointer imageIO2 = itk::itkiOSImageIO::New();
	
	UIImage* displayedImage = _itkView.image;
	
	CGImageRef theImageRef= [displayedImage CGImage];
	size_t numBitsPerPixel = CGImageGetBitsPerPixel(theImageRef);
	size_t numBitsPerComponent = CGImageGetBitsPerComponent(theImageRef);
	CGSize imageSize = [displayedImage size];
	
	unsigned int nx = imageSize.width;
	unsigned int ny = imageSize.height;
    
	std::cout<<"The image is "<<nx<<" by "<<ny<<" pixels in size"<<std::endl;
	std::cout<<"There are "<<numBitsPerPixel<<" bits per pixel"<<std::endl;
	std::cout<<"There are "<<numBitsPerComponent<<" bits per component"<<std::endl;
	
	CGColorSpaceRef theColourSpace = CGImageGetColorSpace(theImageRef);
	size_t numColourSpaceComponents = CGColorSpaceGetNumberOfComponents(theColourSpace);
	
	if (numColourSpaceComponents == 1)
	{
		std::cout<<"pixel type is grayscale"<<std::endl;
		grayReader->SetImageIO(imageIO1);
		imageIO1->SetFileName(_itkView.image);
		grayReader->SetFileName("UIImage1");
		grayReader->Update();
		
		grayWriter->SetInput(grayReader->GetOutput());
		grayWriter->SetImageIO( imageIO2 );
		
		UIImage* outputImage;
		
		imageIO2->SetFileName(outputImage);
		grayWriter->SetFileName("UIImage2");
		
		grayWriter->Update();
		
		_itkView.image = imageIO2->ReturnOutputImage();
        NSString *outputFilename  = @"/Volumes/Learning/LiveInUGA/2014_spring/8850_ADV_BIO/testiOSItk/testPNG.jpg";
        NSData *photoData = UIImageJPEGRepresentation(imageIO2->ReturnOutputImage(), 1);
        [photoData writeToFile:outputFilename atomically:YES];
	}
	else if (numColourSpaceComponents == 3)	// If the image has 3 components, it may or may not have an alpha
	{
		//CGImageAlphaInfo theAlphaInfo = CGImageGetAlphaInfo(theImageRef);
		
        std::cout<<"pixel type is RGB"<<std::endl;
        
        imageIO1->SetFileName(_itkView.image);
        RGBAReader->SetFileName("temp1");
        RGBAReader->SetImageIO(imageIO1);
        RGBAReader->Update();
        
        
        
        RGBAWriter->SetInput(RGBAReader->GetOutput());
        RGBAWriter->SetFileName("temp2");
        RGBAWriter->SetImageIO( imageIO2 );
        
        UIImage* outputImage;
        
        imageIO2->SetFileName(outputImage);
        
        RGBAWriter->Update();
        
        //_itkView.image = imageIO2->ReturnOutputImage();
        NSString *outputFilename  = @"/Volumes/Learning/LiveInUGA/2014_spring/8850_ADV_BIO/testiOSItk/testJPG.jpg";
        NSData *photoData = UIImageJPEGRepresentation(imageIO2->ReturnOutputImage(), 1);
        [photoData writeToFile:outputFilename atomically:YES];
        
	}//end else if (numColourSpaceComponents == 3)
	else
	{
		std::cout<<"Could not tell the number of colour components. In function itkiOSImageIO::ReadImageInformation()"<<std::endl;
		exit(EXIT_FAILURE);
	}
    
    
    
	
    
    
}

-(IBAction)clickFilter:(id)sender
{
    std::cout<<"Reading image information"<<std::endl;
	
	typedef itk::RGBAPixel<unsigned int> RGBAPixelType;
	typedef unsigned char GrayscalePixelType;
	typedef itk::Image< RGBAPixelType, 2 > RGBAImageType;
	typedef itk::Image< GrayscalePixelType, 2 > GrayscaleImageType;
	typedef itk::ImageFileReader< RGBAImageType > RGBAReaderType;
	typedef itk::ImageFileReader< GrayscaleImageType > GrayscaleReaderType;
	typedef itk::ImageFileWriter< GrayscaleImageType > GrayscaleWriterType;
	typedef itk::RGBToLuminanceImageFilter<RGBAImageType, GrayscaleImageType> RGBAtoGrayscaleFilterType;
	typedef itk::BinaryThresholdImageFilter< GrayscaleImageType, GrayscaleImageType > BinaryThresholdFilterType;
	
	RGBAReaderType::Pointer  RGBAReader = RGBAReaderType::New();
	GrayscaleReaderType::Pointer  grayReader = GrayscaleReaderType::New();
	GrayscaleWriterType::Pointer  grayWriter = GrayscaleWriterType::New();
	RGBAtoGrayscaleFilterType::Pointer  RGBA2GrayFilter = RGBAtoGrayscaleFilterType::New();
	BinaryThresholdFilterType::Pointer  binaryFilter = BinaryThresholdFilterType::New();
	
	itk::itkiOSImageIO::Pointer imageIO1 = itk::itkiOSImageIO::New();
	itk::itkiOSImageIO::Pointer imageIO2 = itk::itkiOSImageIO::New();
	
	UIImage* displayedImage = _itkView.image;
	
	CGImageRef theImageRef= [displayedImage CGImage];
	size_t numBitsPerPixel = CGImageGetBitsPerPixel(theImageRef);
	size_t numBitsPerComponent = CGImageGetBitsPerComponent(theImageRef);
	CGSize imageSize = [displayedImage size];
	
	unsigned int nx = imageSize.width;
	unsigned int ny = imageSize.height;
    
	std::cout<<"The image is "<<nx<<" by "<<ny<<" pixels in size"<<std::endl;
	std::cout<<"There are "<<numBitsPerPixel<<" bits per pixel"<<std::endl;
	std::cout<<"There are "<<numBitsPerComponent<<" bits per component"<<std::endl;
	
	CGColorSpaceRef theColourSpace = CGImageGetColorSpace(theImageRef);
	size_t numColourSpaceComponents = CGColorSpaceGetNumberOfComponents(theColourSpace);
	
	if (numColourSpaceComponents == 1)
	{
		std::cout<<"pixel type is grayscale"<<std::endl;
		grayReader->SetImageIO(imageIO1);
		imageIO1->SetFileName(_itkView.image);
		//grayReader->SetFileName("UIImage");
		grayReader->Update();
		
		binaryFilter->SetInput(grayReader->GetOutput());
		
		binaryFilter->SetOutsideValue(0);
		binaryFilter->SetInsideValue(255);
		
		binaryFilter->SetLowerThreshold(0.3*255);
		binaryFilter->SetUpperThreshold(0.7*255);
		
		std::cout<<"update binaryFilter"<<std::endl;
		binaryFilter->Update();
		
		grayWriter->SetInput(binaryFilter->GetOutput());
		grayWriter->SetImageIO( imageIO2 );
		
		UIImage* outputImage;
		
		imageIO2->SetFileName(outputImage);
		//grayWriter->SetFileName("UIImage");
		
		grayWriter->Update();
		
		_itkView.image = imageIO2->ReturnOutputImage();
	}
	else if (numColourSpaceComponents == 3)	// If the image has 3 components, it may or may not have an alpha
	{
		//CGImageAlphaInfo theAlphaInfo = CGImageGetAlphaInfo(theImageRef);
		
        std::cout<<"pixel type is RGB"<<std::endl;
        
        imageIO1->SetFileName(_itkView.image);
        RGBAReader->SetFileName("temp1");
        RGBAReader->SetImageIO(imageIO1);
        RGBAReader->Update();
        
        RGBA2GrayFilter->SetInput(RGBAReader->GetOutput());
        RGBA2GrayFilter->Update();
        
        binaryFilter->SetInput(RGBA2GrayFilter->GetOutput());
        
        binaryFilter->SetOutsideValue(0);
        binaryFilter->SetInsideValue(255);
        
        binaryFilter->SetLowerThreshold(0.3*255);
        binaryFilter->SetUpperThreshold(0.7*255);
        
        std::cout<<"update binaryFilter"<<std::endl;
        binaryFilter->Update();
        
        grayWriter->SetInput(binaryFilter->GetOutput());
        grayWriter->SetFileName("temp2");
        grayWriter->SetImageIO( imageIO2 );
        
        UIImage* outputImage;
        
        imageIO2->SetFileName(outputImage);
        
        
        grayWriter->Update();
        
        _itkView.image = imageIO2->ReturnOutputImage();
	}//end else if (numColourSpaceComponents == 3)
	else
	{
		std::cout<<"Could not tell the number of colour components. In function itkiOSImageIO::ReadImageInformation()"<<std::endl;
		exit(EXIT_FAILURE);
	}

}

/*

-(IBAction)clickShow:(id)sender
{
    
    // We are converting read data into RGBA pixel image
    typedef unsigned char ComponentType;
    //typedef itk::RGBAPixel<ComponentType> RGBAPixelType;
    //typedef itk::Image<RGBAPixelType,2> RGBAImageType;
    
    typedef itk::RGBPixel<ComponentType> RGBPixelType;
    typedef itk::Image<RGBPixelType,2> RGBImageType;
    
    const char * inputFilename  = "/Volumes/Learning/LiveInUGA/2014_spring/8850_ADV_BIO/testiOSItk/BrainProtonDensitySliceBorder20.png";
    
    
    
    // Read in the image
    itk::PNGImageIO::Pointer io;
    io = itk::PNGImageIO::New();
    
    itk::ImageFileReader<RGBImageType>::Pointer reader;
    reader = itk::ImageFileReader<RGBImageType>::New();
    reader->SetFileName(inputFilename);
    reader->SetImageIO(io);
    reader->Update();
    io->ReadImageInformation();
    itk::ImageIORegion::SizeType size = io->GetIORegion().GetSize();
    

    
    //void* mybuffer=malloc(size[0]*size[1]*8);
    size_t numberOfPixels=io->GetIORegion().GetNumberOfPixels();
    size_t numberOfComponent = io->GetComponentType();
    unsigned char* buffer = reinterpret_cast<unsigned char*>(reader->GetOutput()->GetBufferPointer());
    
    // Pixel Container cannot be used/
    //unsigned char* buffer =reinterpret_cast<unsigned char*>(reader->GetOutput()->GetPixelContainer());
    //void* test = malloc(numberOfPixels*numberOfComponent);
    //memcpy(test, buffer, numberOfPixels*numberOfComponent);
    NSData *imageData = [NSData dataWithBytes:(const void*)buffer length:numberOfPixels*numberOfComponent];
    
    unsigned char* test = (unsigned char*) [imageData bytes];
    UIImage *image = [UIImage imageWithData:imageData];
    NSData* newPixelData = [NSData dataWithBytes:buffer length:numberOfPixels*numberOfComponent];
    CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)newPixelData);
    
    
    CGImageRef image1 = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
    
    
    // get PNG properties from cRef
    size_t width = size[0];
    size_t height = size[1];
    size_t bitsPerComponent = 3*8;
   
    size_t bytesPerRow = 3*8*width;
    

    CGColorSpaceRef colorSpace = RGBImageType;
    
    CGBitmapInfo info = CGImageGetBitmapInfo(cRef);
    CGFloat *decode = NULL;
    BOOL shouldInteroplate = NO;
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(cRef);
    
    // cRef PNG properties + imgDataProvider's data
    CGImageRef throughCGImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, info, imgDataProvider, decode, shouldInteroplate, intent);
    CGDataProviderRelease(imgDataProvider);
    
    //NSLog(@"c %i, throughCGImage: %i", CGImageGetHeight(cRef), CGImageGetHeight(throughCGImage) );
    CGImageRelease(throughCGImage);
    
    // make UIImage with CGImage
    UIImage* newImage = [UIImage imageWithCGImage:throughCGImage];
    
   
    

    
    
    
    
    
    //CGImageRef theImageRef = CGImageCreate(width, height,bitsPerComponent,bitsPerPixel,bytesPerRow,colorSpace,bitmapInfo,theDataProvider,nil,shouldInterpolate,theIntent);
    
    std::cout << "ITK Hello World !" << std::endl;
    
    

}*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString* imageType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((CFStringRef)imageType,kUTTypeImage, 0)== kCFCompareEqualTo)
    {
        NSURL *imagePath = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        __block UIImage *chosenImage = nil;
        [library assetForURL:imagePath resultBlock:^(ALAsset *asset) {
            chosenImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]]; //Retain Added
            _itkView.image = chosenImage;
            [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
        } failureBlock:^(NSError *error) {
            // error handling
        }];
        //[library release];
        //NSData* data = [NSData dataWithContentsOfURL:imagePath];
        //UIImage *chosenImage = [UIImage imageWithData:data ];
        
    }
    
    
    
    
    
}


@end
