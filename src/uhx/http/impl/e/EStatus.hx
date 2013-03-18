package uhx.http.impl.e;

/**
 * ...
 * @author Skial Bainn
 */

enum EStatus {
	@code(100) Continue;
	@code(101) Switching_Protocols;
	@code(102) Processing;
	
	@code(200) OK;
	@code(201) Created;
	@code(202) Accepted;
	@code(203) Non_Authorithative_Information;
	@code(204) No_Content;
	@code(205) Reset_Content;
	@code(206) Partial_Content;
	@code(207) Multi_Status;
	@code(208) Already_Reported;
	@code(250) Low_on_Storage_Space;
	@code(226) IM_Used;
	
	@code(300) Multiple_Choices;
	@code(301) Moved_Permanently;
	@code(302) Found;
	@code(303) See_Other;
	@code(304) Not_Modified;
	@code(305) Use_Proxy;
	@code(306) Switch_Proxy;
	@code(307) Temporary_Redirect;
	@code(308) Permanent_Redirect;
	
	@code(400) Bad_Request;
	@code(401) Unauthorized;
	@code(402) Payment_Required;
	@code(403) Forbidden;
	@code(404) Not_Found;
	@code(405) Method_Not_Allowed;
	@code(406) Not_Acceptable;
	@code(407) Proxy_Authentication_Required;
	@code(408) Request_Timeout;
	@code(409) Conflict;
	@code(410) Gone;
	@code(411) Length_Required;
	@code(412) Precondition_Failed;
	@code(413) Request_Entity_Too_Large;
	@code(414) Request_URI_Too_Long;
	@code(415) Unsupported_Media_Type;
	@code(416) Requested_Range_Not_Satisfiable;
	@code(417) Expectation_Failed;
	@code(422) Unprocessable_Entity;
	@code(423) Locked;
	@code(424) Failed_Dependency;
	@code(424) Method_Failure;
	@code(425) Unordered_Collection;
	@code(426) Upgrade_Required;
	@code(429) Too_Many_Requests;
	@code(431) Request_Header_Fields_Too_Large;
	@code(444) No_Response;
	@code(449) Retry_With;
	
	@code(500) Internal_Server_Error;
	@code(501) Not_Implemented;
	@code(502) Bad_Gateway;
	@code(503) Service_Unavailable;
	@code(504) Gateway_Timeout;
	@code(505) HTTP_Version_Not_Supported;
	@code(506) Variant_Also_Negotiates;
	@code(507) Insufficient_Storage;
	@code(508) Loop_Detected;
	@code(509) Bandwidth_Limit_Exceeded;
	@code(510) Not_Extended;
	@code(511) Network_Authentication_Required;
	
}