/*=========================================================================
 
 Program:   Insight Segmentation & Registration Toolkit
 Module:    $RCSfile: itkYAFFImageIO.cxx,v $
 Language:  C++
 Date:      $Date: 2007/03/29 18:39:28 $
 Version:   $Revision: 1.69 $
 
 Copyright (c) Insight Software Consortium. All rights reserved.
 See ITKCopyright.txt or http://www.itk.org/HTML/Copyright.htm for details.
 
 This software is distributed WITHOUT ANY WARRANTY; without even 
 the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
 PURPOSE.  See the above copyright notices for more information.
 
 =========================================================================*/
/*
 *  itkiOSImageIO.cpp
 *  itkPhoneWithIphoneXcodeBuild
 *
 *  Created by Boris Shabash, Ghassan Hamarneh,  Zhi Feng Huang , and Luis Ibanez on01/05/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *	
 *	Created using the template itkYAFFImageIO.cxx file.
 *
 */

//	Copyright 2010 Boris Shabash, Ghassan Hamarneh, Zhi Feng Huang, and Luis Ibanez
//	
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.


#ifdef _MSC_VER
#pragma warning ( disable : 4786 )
#endif

#include "itkExceptionObject.h"
#include "itkIOCommon.h"
#include "itkiOSImageIO.h"
#include "itksys/SystemTools.hxx"

namespace itk
{
	
	itkiOSImageIO::itkiOSImageIO()
	{
		m_OutputUIImagePointer = NULL;
		m_UIImagePointer = NULL;
		this->SetNumberOfDimensions(2); // iPhone UIImages are 2D.
		//		this->SetNumberOfComponents(3); // iPhone UIImages have 3 components RGB.
	} 
	
	/************************************************************************************************************/
	
	itkiOSImageIO::~itkiOSImageIO()
	{
		std::cout<<"itkiOSImageIO::~itkiOSImageIO() destructor called"<<std::endl;
	}
	
	/************************************************************************************************************/	
	
	void itkiOSImageIO::PrintSelf(std::ostream& os, Indent indent) const
	{
		Superclass::PrintSelf(os, indent);
	}
	
	/************************************************************************************************************/
	void itkiOSImageIO::SetFileName(UIImage* theImage)
	{
		std::cout << "itkiOSImageIO::SetFileName() " << std::endl;
		if (theImage == NULL)
		{
			std::cout<<"The image supplied is a NULL pointer"<<std::endl;
		}//end if (theImage == NULL)
		
		m_UIImagePointer = theImage;		
		std::cout << "itkiOSImageIO::SetFileName() end" << std::endl;
	}
	/************************************************************************************************************/	
	bool itkiOSImageIO::CanReadFile(const char* filename) 
	{ 
		std::cout << "itkiOSImageIO::CanReadFile() " << std::endl;
		
		//
		// Strings are not a valid output directory for this object
		//
		
		std::cout<<"Image is not a UIImage type"<<std::endl;
		return false;
	}
	
	/************************************************************************************************************/
	
	bool itkiOSImageIO::CanReadFile(UIImage* theImage)
	{
		std::cout << "itkiOSImageIO::CanReadFile() " << std::endl;
		
		//
		// If the pointer is null, we can't read
		// the image.
		//
		
		if (theImage == NULL)
		{
			std::cout<<"The image supplied is a NULL pointer"<<std::endl;
			return false;
		}//end if (theImage == NULL)
		
		m_UIImagePointer = theImage;
		return true;
		std::cout << "itkiOSImageIO::CanReadFile() end" << std::endl;
	}// end CanReadFile(UIImage* theImage)
	
	/************************************************************************************************************/
	
	void itkiOSImageIO::ReadImageInformation()
	{ 	
		// Get the image reference
		CGImageRef theImageRef= [m_UIImagePointer CGImage];
		
		// Size and dimensions of the image
//		CGSize imageSize = [m_UIImagePointer size];
//		
//		unsigned int nx = imageSize.width;
//		unsigned int ny = imageSize.height;
		
		unsigned int nx = CGImageGetWidth(theImageRef);
		unsigned int ny = CGImageGetHeight(theImageRef);
		
		// Set the dimensions to be accessible permenentaly 
		this->SetDimensions(0, nx);
		this->SetDimensions(1, ny);
		
		// Not critical stuff
		size_t numBitsPerPixel = CGImageGetBitsPerPixel(theImageRef);
//		switch (numBitsPerPixel)
//		{
//			case 8:
//				this->SetComponentType(UCHAR);
//				std::cout<<"component type = uchar "<<std::endl;
//				break;
//			case 16:
//				this->SetComponentType(USHORT);
//				std::cout<<"component type = ushort "<<std::endl;
//				break;
//			case 32:
//				this->SetComponentType(UINT);
//				std::cout<<"component type = uint "<<std::endl;
//				break;
//			case 64:
//				this->SetComponentType(ULONG);
//				std::cout<<"component type = ulong "<<std::endl;
//				break;
//		}
		size_t numBitsPerComponent = CGImageGetBitsPerComponent(theImageRef);
		switch (numBitsPerComponent)
		{
			case 8:
				this->SetComponentType(UCHAR);
				std::cout<<"component type = uchar "<<std::endl;
				break;
			case 16:
				this->SetComponentType(USHORT);
				std::cout<<"component type = ushort "<<std::endl;
				break;
			case 32:
				this->SetComponentType(UINT);
				std::cout<<"component type = uint "<<std::endl;
				break;
			case 64:
				this->SetComponentType(ULONG);
				std::cout<<"component type = ulong "<<std::endl;
				break;
		}
		
		std::cout<<"The image is "<<nx<<" by "<<ny<<" pixels in size"<<std::endl;
		std::cout<<"There are "<<numBitsPerPixel<<" bits per pixel"<<std::endl;
		std::cout<<"There are "<<numBitsPerComponent<<" bits per component"<<std::endl;
		
		CGColorSpaceRef theColourSpace = CGImageGetColorSpace(theImageRef);
		
		std::cout<<"The colour space used is "<<theColourSpace<<std::endl;
		
		size_t numColourSpaceComponents = CGColorSpaceGetNumberOfComponents(theColourSpace);
		
		if (numColourSpaceComponents == 1) 
		{
			this->SetPixelType(SCALAR);	// If the image is grayscale, it has only 1 channel
			this->SetNumberOfComponents(1);
		}
		else if (numColourSpaceComponents == 3)	// If the image has 3 components, it may or may not have an alpha
		{
			this->SetNumberOfComponents(3);
			CGImageAlphaInfo theAlphaInfo = CGImageGetAlphaInfo(theImageRef);
			
			if((theAlphaInfo == kCGImageAlphaNone) /*||
			   (theAlphaInfo == kCGImageAlphaNoneSkipLast) ||
			   (theAlphaInfo == kCGImageAlphaNoneSkipFirst)*/)
			{
				this->SetPixelType(RGB);	// Otherwise the image is RGB (no alpha)
				std::cout<<"pixel type is RGB"<<std::endl;
			}//end if((theAlphaInfo == kCGImageAlphaNone) || (theAlphaInfo == kCGImageAlphaNoneSkipLast) || (theAlphaInfo == kCGImageAlphaNoneSkipFirst))
			else if ((theAlphaInfo == kCGImageAlphaPremultipliedFirst) ||
					 (theAlphaInfo == kCGImageAlphaPremultipliedLast) ||
					 (theAlphaInfo == kCGImageAlphaFirst) ||
					 (theAlphaInfo == kCGImageAlphaNoneSkipLast) ||
					 (theAlphaInfo == kCGImageAlphaNoneSkipFirst) ||
					 (theAlphaInfo == kCGImageAlphaLast))
			{
				this->SetNumberOfComponents(4);
				this->SetPixelType(RGBA);
				std::cout<<"pixel type is RGBA"<<std::endl;
			}//end else if ((theAlphaInfo == kCGImageAlphaPremultipliedFirst) || (theAlphaInfo == kCGImageAlphaPremultipliedLast) || (theAlphaInfo == kCGImageAlphaFirst) || (theAlphaInfo == kCGImageAlphaLast))
			else
			{
				std::cout<<"Could not tell pixel type. In function itkiOSImageIO::ReadImageInformation()"<<std::endl;
				exit(EXIT_FAILURE);
			}
			
		}//end else if (numColourSpaceComponents == 3)
		else
		{
			std::cout<<"Could not tell the number of colour components. In function itkiOSImageIO::ReadImageInformation()"<<std::endl;
			exit(EXIT_FAILURE);
		}
		
		std::cout<<"There are "<<numColourSpaceComponents<<" components to the colour space"<<std::endl;
		
		
		// Still need to extract tropicity of the image
		// For now, assume isotropic
		this->SetSpacing( 0, 1.0);
		this->SetSpacing( 1, 1.0);
		return;
	}
	
	/************************************************************************************************************/
	
	void itkiOSImageIO::Read( void * buffer)
	{ 
		std::cout << "itkiOSImageIO::Read() Begin" << std::endl;
		
		// The following code is taken from http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
		
		//	Get the image ref
		if (m_UIImagePointer == NULL)
		{
			std::cout<<"The image is not loaded into the reader. Cannot read info from a NULL"<<std::endl;
			return;
		}
		
		CGImageRef theImageRef = [m_UIImagePointer CGImage];
		
		// Get image size
		NSUInteger width = this->GetDimensions(0);
		NSUInteger height = this->GetDimensions(1);
		std::cout<<"width = "<<width<<std::endl;
		std::cout<<"height = "<<height<<std::endl;
		
		// Set up all parameters to create the new image context that will house the 
		// image information
		CGColorSpaceRef colorSpace;
		CGBitmapInfo theBitmapInfo;
		NSUInteger bytesPerPixel;
		
		if (this->GetPixelType() == SCALAR)	// If this image is a graysacle where each pixel has only
			// one value (scalar)...
		{
			colorSpace = CGColorSpaceCreateDeviceGray();
			bytesPerPixel = 1;														// Use 1 byte per pixel
			theBitmapInfo = kCGImageAlphaNone;// | kCGBitmapByteOrder32Big;
			std::cout<<"Using Scalar pixel type"<<std::endl;
		}//end if (this->GetPixelType() == SCALAR)
		else if (this->GetPixelType() == RGB)	// If this image is only an RGB image then each pixel
			// has 3 values
		{
			colorSpace = CGColorSpaceCreateDeviceRGB();
			bytesPerPixel = 4;														// Use 3 bytes per pixel
			theBitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big;
			std::cout<<"Using RGB pixel type"<<std::endl;
		}//end else if (this->GetPixelType() == RGB)
		else if (this->GetPixelType() == RGBA)
		{
			colorSpace = CGColorSpaceCreateDeviceRGB();
			bytesPerPixel = 4;														// Use 4 bytes per pixel
			theBitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
			std::cout<<"Using RGBA pixel type"<<std::endl;
		}//end else if (this->GetPixelType() == RGBA)
		else
		{
			std::cout<<"Unknown pixel type for this image. In function itkiOSImageIO::Read()"<<std::endl;
			exit(EXIT_FAILURE);
		}//end else
		
		std::cout<<"setting parameters"<<std::endl;
		
		NSUInteger bytesPerRow = bytesPerPixel * width;
		NSUInteger bitsPerComponent = 8;													// One byte for every component
		
		std::cout<<"creating context"<<std::endl;
		// Now create the new image context (basically the new image data placeholder)
		CGContextRef context = CGBitmapContextCreate(buffer, 
													 width, 
													 height, 
													 bitsPerComponent, 
													 bytesPerRow, 
													 colorSpace, 
													 theBitmapInfo);
		std::cout<<"releasing colour space"<<std::endl;
		CGColorSpaceRelease(colorSpace);
		
		// Draw the image of interest into the new context
		std::cout<<"draw image"<<std::endl;
		CGContextDrawImage(context, CGRectMake(0, 0, width, height), theImageRef);
		CGContextRelease(context);
		
		std::cout<<"performing cast"<<std::endl;
//		const char *rawData = static_cast<const char*> (buffer);
		
		//		for (int y=0; y<height;y++)
		//		{
		//			for (int x=0; x<width; x++)
		//			{
		//				unsigned int byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
		//				unsigned char red = rawData[byteIndex];
		//				std::cout<<"red is:"<<static_cast<unsigned int>(red)<<std::endl;
		//				unsigned char green = rawData[byteIndex + 1];
		//				std::cout<<"green is:"<<static_cast<unsigned int>(green)<<std::endl;
		//				unsigned char blue = rawData[byteIndex + 2];
		//				std::cout<<"blue is:"<<static_cast<unsigned int>(blue)<<std::endl;
		//				unsigned char alpha = rawData[byteIndex + 3];
		//				std::cout<<"alpha is:"<<static_cast<unsigned int>(alpha)<<std::endl;
		//			}
		//		}
		
		std::cout << "itkiOSImageIO::Read() End" << std::endl;
	} 
	
	/************************************************************************************************************/	
	
	bool itkiOSImageIO::CanWriteFile(const char* name)
	{
		//
		// Strings are not a valid output directory for this object
		//
		
		std::cout<<"Image is not a UIImage type"<<std::endl;
		return false;
	}
	/************************************************************************************************************/	
	
	bool itkiOSImageIO::CanWriteFile(UIImage* theOutputImage)
	{
		//
		// It can write to UIImage objects just fine.
		// If the output image is also required for further use (display on screen)
		// this method will have an additional pointer pointing to the output image
		//
		
		theOutputImage = m_OutputUIImagePointer;
		
		return true;
	}//end CanWriteFile(UIImage* theOutputImage)
	/************************************************************************************************************/	
	
	void 
	itkiOSImageIO
	::WriteImageInformation(void)
	{
		// Unfortunatly, the way UIImages work, it's much more convinient to write the image 
		// information along with the actual image.
	}//end WriteImageInformation(void)
	
	/************************************************************************************************************/	
	
	/**
	 *
	 */
	void 
	itkiOSImageIO
	::Write( const void* buffer) 
	{
		std::cout << "itkiOSImageIO::Write() Begin" << std::endl;
		
		// Set the dimensions of the current context
		size_t width = this->GetDimensions(0);
		size_t height = this->GetDimensions(1);
		std::cout<<"width = "<<width<<std::endl;
		std::cout<<"height = "<<height<<std::endl;
		
		// 1 byte per component
		size_t bitsPerComponent = 8;
		unsigned int multiplier;
		if (this->GetComponentType() == UCHAR)
		{
			multiplier = 1;
		}
		else if (this->GetComponentType() == USHORT)
		{
			multiplier = 2;
		}
		else if (this->GetComponentType() == UINT)
		{
			multiplier = 4;
		}
		else if (this->GetComponentType() == ULONG)
		{
			multiplier = 8;
		}
		bitsPerComponent *= multiplier;
		
		std::cout<<"multiplier = "<<multiplier<<std::endl;
		std::cout<<"writing "<<this->GetNumberOfComponents()<<" components"<<std::endl;
//		std::cout<<"multiplier = "<<multiplier<<std:endl;
		
		// These elements depend on the image so we will have to declare them
		// and then set their values
		size_t bitsPerPixel, bytesPerRow;
		CGColorSpaceRef colorSpace;
		CGBitmapInfo bitmapInfo;
		CGDataProviderRef theDataProvider;
		CFDataRef theDataReference;
		bool shouldInterpolate = NO;
		CGColorRenderingIntent theIntent;
		
		
		// Resolve the values of the image parameters
		if (this->GetPixelType() == SCALAR)	// If this image is a graysacle where each pixel has only
			// one value (scalar)...
		{
			bitsPerPixel = bitsPerComponent * 1;
			colorSpace = CGColorSpaceCreateDeviceGray();
			bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrder32Big;
			std::cout << "Using scalar pixel type" << std::endl;
		}//end if (this->GetPixelType() == SCALAR)
		else if (this->GetPixelType() == RGB)	// If this image is only an RGB image then each pixel
			// has 3 values
		{
			bitsPerPixel = bitsPerComponent*3;
			colorSpace = CGColorSpaceCreateDeviceRGB();
			bitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big;
			std::cout << "using RGB pixel type" << std::endl;
		}//end else if (this->GetPixelType() == RGB)
		else if (this->GetPixelType() == RGBA)
		{
			bitsPerPixel = bitsPerComponent*4;
			colorSpace = CGColorSpaceCreateDeviceRGB();
			bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
			std::cout << "using RGBA pixel type" << std::endl;
		}//end else if (this->GetPixelType() == RGBA)
		else
		{
			std::cout<<"Unknown pixel type for this image. In function itkiOSImageIO::Write()"<<std::endl;
			exit(EXIT_FAILURE);
		}//end else
		
		
		// Construct a CG data provider to build the CG image
		const UInt8* rawData = static_cast<const UInt8*>(buffer);
		
		// For some reason initiating a CGImage uses BITS per pixel, so we need to divide by 8 to get BYTES 
		// per pixel		
		bytesPerRow = (bitsPerPixel/8) * width;
		
		theDataReference = CFDataCreate(NULL,
										rawData,
										(bytesPerRow*height));
		
		theDataProvider = CGDataProviderCreateWithCFData(theDataReference);
		
		
		
		// Finally create the image reference
		CGImageRef theImageRef = CGImageCreate(width,
											   height,
											   bitsPerComponent,
											   bitsPerPixel,
											   bytesPerRow,
											   colorSpace,
											   bitmapInfo,
											   theDataProvider,
											   nil,
											   shouldInterpolate,
											   theIntent);
		
		
		// Construct an output image
		m_OutputUIImagePointer = [UIImage imageWithCGImage:(theImageRef)];
		
		// Write the image to the album. If the output image is required for other means,
		// please view the CanWriteFile(UIImage*) method
		UIImageWriteToSavedPhotosAlbum (m_OutputUIImagePointer,
										NULL,
										NULL,
										NULL);
		std::cout << "itkiOSImageIO::Write() End" << std::endl;
	}//end Write( const void* buffer) 
	
	/************************************************************************************************************/	
	
	/** Given a requested region, determine what could be the region that we can
	 * read from the file. This is called the streamable region, which will be
	 * smaller than the LargestPossibleRegion and greater or equal to the 
	 RequestedRegion */
	ImageIORegion 
	itkiOSImageIO
	::GenerateStreamableReadRegionFromRequestedRegion( const ImageIORegion & requested ) const
	{
		std::cout << "itkiOSImageIO::GenerateStreamableReadRegionFromRequestedRegion()" << std::endl;
		std::cout << "Requested region = " << requested << std::endl;
		//
		// YAFF is the ultimate streamer.
		//
		ImageIORegion streamableRegion = requested;
		
		std::cout << "StreamableRegion = " << streamableRegion << std::endl;
		
		return streamableRegion;
	}//end GenerateStreamableReadRegionFromRequestedRegion( const ImageIORegion & requested ) const
	
	/************************************************************************************************************/	
	
	UIImage* itkiOSImageIO::ReturnOutputImage()
	{
		return m_OutputUIImagePointer;
	}
	
	
} // end namespace itk
