/*=========================================================================
 
 Program:   Insight Segmentation & Registration Toolkit
 Module:    $RCSfile: itkYAFFImageIO.h,v $
 Language:  C++
 Date:      $Date: 2007/03/22 14:28:51 $
 Version:   $Revision: 1.31 $
 
 Copyright (c) Insight Software Consortium. All rights reserved.
 See ITKCopyright.txt or http://www.itk.org/HTML/Copyright.htm for details.
 
 This software is distributed WITHOUT ANY WARRANTY; without even 
 the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
 PURPOSE.  See the above copyright notices for more information.
 
 =========================================================================*/

/*
 *  itkiOSImageIO.h
 *  itkPhoneWithIphoneXcodeBuild
 *
 *  Created by Boris Shabash, Ghassan Hamarneh,  Zhi Feng Huang , and Luis Ibanez on27/04/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *	
 *	This file was produced using the template itkYAFFImageIO. All I did here was replace 
 *	the name YAFFImageIO with itkiOSImageIO and change the arguments of the functions.
 *	The majority of the code is still written by ITK developers. This is designed only as
 *	a skeleton code for the final product
 *	
 *	Note that in the build process this file is not actually compiled (since it isn't
 *	included anywhere). It doesn't implement several virtual methods so including it
 *	introduces errors.
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



#ifndef __itkiOSImageIO_h
#define __itkiOSImageIO_h

#ifdef _MSC_VER
#pragma warning ( disable : 4786 )
#endif

#include "itkImageIOBase.h"
#include <fstream>

namespace itk
{
	//	class UIImage*;
	
	class ITK_EXPORT itkiOSImageIO : public ImageIOBase
	{
	public:
		/** Standard class typedefs. */
		typedef itkiOSImageIO        Self;
		typedef ImageIOBase        Superclass;
		typedef SmartPointer<Self> Pointer;
		
		/** Method for creation through the object factory. */
		itkNewMacro(Self);
		
		/** Run-time type information (and related methods). */
		itkTypeMacro(itkiOSImageIO, ImageIOBase);
		
		/*-------- This part of the interfaces deals with reading data. ----- */
		
		virtual void SetFileName(UIImage*);
		
		/** Determine the file type. Returns true if this ImageIO can read the
		 * file specified. */
		virtual bool CanReadFile(const char*);
		
		// Overload with a UIImage as an argument
		virtual bool CanReadFile(UIImage*);
		
		/** Set the spacing and dimension information for the set filename. */
		virtual void ReadImageInformation();
		
		/** Reads the data from disk into the memory buffer provided. */
		virtual void Read(void* buffer);
		
		/*-------- This part of the interfaces deals with writing data. ----- */
		
		/** Determine the file type. Returns true if this ImageIO can write the
		 * file specified. */
		virtual bool CanWriteFile(const char*);
		
		// Overload with a UIImage as an argument
		virtual bool CanWriteFile(UIImage*);
		
		/** Set the spacing and dimension information for the set filename. */
		virtual void WriteImageInformation();
		
		/** Writes the data to disk from the memory buffer provided. Make sure
		 * that the IORegions has been set properly. */
		virtual void Write(const void* buffer);
		
		/** Method for supporting streaming.  Given a requested region, determine what
		 * could be the region that we can read from the file. This is called the
		 * streamable region, which will be smaller than the LargestPossibleRegion and
		 * greater or equal to the RequestedRegion */
		virtual ImageIORegion 
		GenerateStreamableReadRegionFromRequestedRegion( const ImageIORegion & requested ) const;
		
		UIImage* ReturnOutputImage();
		
		
	protected:
		itkiOSImageIO();
		~itkiOSImageIO();
		void PrintSelf(std::ostream& os, Indent indent) const;
		
	private:
		itkiOSImageIO(const Self&); //purposely not implemented
		void operator=(const Self&); //purposely not implemented
		
		std::ifstream     m_InputStream;
		std::ofstream     m_OutputStream;
		std::string		  m_RawDataFilename;
		UIImage*		  m_UIImagePointer;
		UIImage*		  m_OutputUIImagePointer;
		
	};
	
} // end namespace itk

#endif // __itkiOSImageIO_h
