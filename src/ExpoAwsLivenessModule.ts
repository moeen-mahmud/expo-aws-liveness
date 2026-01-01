import { NativeModule, requireNativeModule } from "expo";

import type { CognitoConfig, ExpoAwsLivenessModuleEvents, ExpoAwsLivenessResult } from "./ExpoAwsLiveness.types";

declare class ExpoAwsLivenessModuleType extends NativeModule<ExpoAwsLivenessModuleEvents> {
	/**
	 * Configure Amplify with Cognito Identity Pool credentials
	 * Must be called before starting a liveness session
	 * @param config - Cognito configuration with region and identityPoolId
	 */
	configure(config: CognitoConfig): Promise<void>;

	/**
	 * Start a face liveness detection session
	 * @param sessionId - The session ID obtained from your backend's create-session API
	 * @returns Promise resolving to the liveness result
	 */
	startLivenessSession(sessionId: string): Promise<ExpoAwsLivenessResult>;
}

// This call loads the native module object from the JSI
export default requireNativeModule<ExpoAwsLivenessModuleType>("ExpoAwsLiveness");
