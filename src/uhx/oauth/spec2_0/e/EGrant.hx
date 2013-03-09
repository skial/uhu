package uhx.oauth.spec2_0.e;

/**
 * ...
 * @author Skial Bainn
 */

enum EGrant {
	Authorization_Code;
	Implicit;
	Password;
	Client_Credentials;
	Extension(method:Void->Void);
}