import { NitroModules } from 'react-native-nitro-modules'
import type { NitroBaiduGeolocation as NitroBaiduGeolocationSpec } from './specs/nitro-baidu-geolocation.nitro'

export const NitroBaiduGeolocation =
  NitroModules.createHybridObject<NitroBaiduGeolocationSpec>('NitroBaiduGeolocation')