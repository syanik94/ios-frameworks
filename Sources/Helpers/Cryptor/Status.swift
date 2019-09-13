//
//  Status.swift
//  Cryptor
//
// 	Licensed under the Apache License, Version 2.0 (the "License");
// 	you may not use this file except in compliance with the License.
// 	You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// 	Unless required by applicable law or agreed to in writing, software
// 	distributed under the License is distributed on an "AS IS" BASIS,
// 	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 	See the License for the specific language governing permissions and
// 	limitations under the License.
//

import Foundation
import CommonCrypto

///
/// Links the native CommonCryptoStatus enumeration to Swift versions.
///
public enum Status: CCCryptorStatus, Swift.Error, CustomStringConvertible {

    /// Successful
    case success

    /// Parameter Error
    case paramError

    /// Buffer too Small
    case bufferTooSmall

    /// Memory Failure
    case memoryFailure

    /// Alignment Error
    case alignmentError

    /// Decode Error
    case decodeError

    /// Unimplemented
    case unimplemented

    /// Overflow
    case overflow

    /// Random Number Generator Err
    case rngFailure

    ///
    /// Converts this value to a native `CCCryptorStatus` value.
    ///
    public func toRaw() -> CCCryptorStatus {

        switch self {

        case .success:
            return CCCryptorStatus(kCCSuccess)
        case .paramError:
            return CCCryptorStatus(kCCParamError)
        case .bufferTooSmall:
            return CCCryptorStatus(kCCBufferTooSmall)
        case .memoryFailure:
            return CCCryptorStatus(kCCMemoryFailure)
        case .alignmentError:
            return CCCryptorStatus(kCCAlignmentError)
        case .decodeError:
            return CCCryptorStatus(kCCDecodeError)
        case .unimplemented:
            return CCCryptorStatus(kCCUnimplemented)
        case .overflow:
            return CCCryptorStatus(kCCOverflow)
        case .rngFailure:
            return CCCryptorStatus(kCCRNGFailure)
        }
    }

    ///
    /// Human readable descriptions of the values. (Not needed in Swift 2.0?)
    ///
    static let descriptions = [
        success: "Success",
        paramError: "ParamError",
        bufferTooSmall: "BufferTooSmall",
        memoryFailure: "MemoryFailure",
        alignmentError: "AlignmentError",
        decodeError: "DecodeError",
        unimplemented: "Unimplemented",
        overflow: "Overflow",
        rngFailure: "RNGFailure"
    ]

    ///
    /// Obtain human-readable string from enum value.
    ///
    public var description: String {

        return (Status.descriptions[self] != nil) ? Status.descriptions[self]! : ""
    }

    ///
    /// Create enum value from raw `CCCryptorStatus` value.
    ///
    public static func fromRaw(status: CCCryptorStatus) -> Status? {

        let from = [
            kCCSuccess: success,
            kCCParamError: paramError,
            kCCBufferTooSmall: bufferTooSmall,
            kCCMemoryFailure: memoryFailure,
            kCCAlignmentError: alignmentError,
            kCCDecodeError: decodeError,
            kCCUnimplemented: unimplemented,
            kCCOverflow: overflow,
            kCCRNGFailure: rngFailure
        ]

        return from[Int(status)]

    }
}

///
/// CryptorError
///		Thrown in caaes where a _fatalError()_ is **NOT** appropriate.
///
public enum CryptorError: Swift.Error, CustomStringConvertible {

	/// Success
	case success
	
	/// Invalid key size
	case invalidKeySize
	
	/// Invalid IV size
	case invalidIVSizeOrLength
	
	/// Fail with code and string
	case fail(Int32, String)
	
	/// The error code itself
	public var errCode: Int32 {
		
		switch self {
			
		case .success:
			return 0
			
		case .invalidKeySize:
			return -1
			
		case .invalidIVSizeOrLength:
			return -2
			
		case .fail(let errCode, _):
			return Int32(errCode)
		}
	}
	
	/// Error Description
	public var description: String {
		
		switch self {
			
		case .success:
			return "Success"
			
		case .invalidKeySize:
			return "Invalid key size."
			
		case .invalidIVSizeOrLength:
			return "Invalid IV size or length."
			
		case .fail(let (_, reason)):
			return reason
		}
	}
}

