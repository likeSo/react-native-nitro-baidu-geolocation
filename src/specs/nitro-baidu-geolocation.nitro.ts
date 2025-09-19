import { type HybridObject } from 'react-native-nitro-modules'
import type { GetLocationOptions, Location } from '../NitroBaiduGeolocation.types';

export interface NitroBaiduGeolocation
  extends HybridObject<{ android: 'kotlin'; ios: 'swift' }> {

  /**
   * 在用户接受了app隐私政策后调用此方法，否则SDK不能正确使用。
   * @param agree 是否接受隐私政策条款。
   */
  agreePrivacyPolicy(agree: boolean): void
  /**
   * 初始化百度SDK。返回授权结果。-1=未知错误。0=鉴权成功。1=因为网络原因鉴权失败。2=KEY校验失败。
   * @param ak 百度授权token。
   */
  initialize(ak: string): Promise<number>
  /**
   * 单次定位。如果当前正在连续定位，调用此方法将会失败，返回false。
   * @param options 定位参数。
   */
  getCurrentLocation(options: GetLocationOptions): Promise<Location>
}
