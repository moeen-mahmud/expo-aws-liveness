// Reexport the native module. On web, it will be resolved to ExpoAwsLivenessModule.web.ts
// and on native platforms to ExpoAwsLivenessModule.ts
export { default } from './ExpoAwsLivenessModule';
export { default as ExpoAwsLivenessView } from './ExpoAwsLivenessView';
export * from  './ExpoAwsLiveness.types';
