package uhx.http.impl;
import uhx.http.impl.e.EStatus;

/**
 * ...
 * @author Skial Bainn
 */

class Status {
	
	public static var fromInt:Map<Int, EStatus> = [
		100=>Continue,
		101=>Switching_Protocols,
		102=>Processing,
		
		200=>OK,
		201=>Created,
		202=>Accepted,
		203=>Non_Authorithative_Information,
		204=>No_Content,
		205=>Reset_Content,
		206=>Partial_Content,
		207=>Multi_Status,
		208=>Already_Reported,
		250=>Low_on_Storage_Space,
		226=>IM_Used,
		
		300=>Multiple_Choices,
		301=>Moved_Permanently,
		302=>Found,
		303=>See_Other,
		304=>Not_Modified,
		305=>Use_Proxy,
		306=>Switch_Proxy,
		307=>Temporary_Redirect,
		308=>Permanent_Redirect,
		
		400=>Bad_Request,
		401=>Unauthorized,
		402=>Payment_Required,
		403=>Forbidden,
		404=>Not_Found,
		405=>Method_Not_Allowed,
		406=>Not_Acceptable,
		407=>Proxy_Authentication_Required,
		408=>Request_Timeout,
		409=>Conflict,
		410=>Gone,
		411=>Length_Required,
		412=>Precondition_Failed,
		413=>Request_Entity_Too_Large,
		414=>Request_URI_Too_Long,
		415=>Unsupported_Media_Type,
		416=>Requested_Range_Not_Satisfiable,
		417=>Expectation_Failed,
		422=>Unprocessable_Entity,
		423=>Locked,
		424=>Failed_Dependency,
		425=>Unordered_Collection,
		426=>Upgrade_Required,
		429=>Too_Many_Requests,
		431=>Request_Header_Fields_Too_Large,
		444=>No_Response,
		449=>Retry_With,
		
		500=>Internal_Server_Error,
		501=>Not_Implemented,
		502=>Bad_Gateway,
		503=>Service_Unavailable,
		504=>Gateway_Timeout,
		505=>HTTP_Version_Not_Supported,
		506=>Variant_Also_Negotiates,
		507=>Insufficient_Storage,
		508=>Loop_Detected,
		509=>Bandwidth_Limit_Exceeded,
		510=>Not_Extended,
		511=>Network_Authentication_Required,
	];
	
}