/**
 * Face Liveness Module Types
 * AWS Amplify Face Liveness integration for React Native
 */

/**
 * Configuration for Cognito Identity Pool
 */
export type CognitoConfig = {
	/** AWS Region (e.g., 'us-east-1') */
	region: string;
	/** Cognito Identity Pool ID */
	identityPoolId: string;
};

/**
 * ExpoAwsLivenessViewProps
 */
export type ExpoAwsLivenessViewProps = {
	/** The session ID obtained from your backend's create-session API */
	sessionId: string;
	/** The region of the AWS Cognito Identity Pool */
	region: string;
	/** The callback function to be called when the liveness session is completed */
	onCompletion: (result: ExpoAwsLivenessResult) => void;
};

/**
 * Result returned from the liveness session
 */
export type ExpoAwsLivenessResult = {
	/** Whether the liveness check was successful */
	isLive: boolean;
	/** The session ID that was checked */
	sessionId: string;
	/** Error message if check failed */
	errorMessage?: string;
	/** Error code for programmatic handling */
	errorCode?: ExpoAwsLivenessErrorCode;
};

/**
 * Possible error codes from the liveness check
 */
export type ExpoAwsLivenessErrorCode =
	| "SESSION_NOT_FOUND"
	| "SESSION_EXPIRED"
	| "USER_CANCELLED"
	| "CAMERA_PERMISSION_DENIED"
	| "FACE_NOT_DETECTED"
	| "MULTIPLE_FACES_DETECTED"
	| "VALIDATION_FAILED"
	| "NETWORK_ERROR"
	| "UNKNOWN_ERROR";

/**
 * Events emitted by the module during liveness session
 */
export type ExpoAwsLivenessModuleEvents = {
	/** Emitted when liveness session status changes */
	onStatusChange: (params: StatusChangePayload) => void;
};

/**
 * Payload for status change events
 */
export type StatusChangePayload = {
	status: "initializing" | "detecting" | "processing" | "completed" | "error";
	message?: string;
};
