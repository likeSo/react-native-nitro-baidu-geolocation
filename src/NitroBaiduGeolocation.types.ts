export type LocationDesiredAccuracy =
  | 'best'
  | 'bestForNavigation'
  | 'nearestTenMeters'
  | 'hundredMeters'
  | 'kilometer'
  | 'threeKilometers'

export type Coordinate = {
  latitude: number
  longitude: number
  altitude: number
}

export type CoordinateType = 'bmk09ll' | 'bmk09mc' | 'wgs84' | 'gcj02'

export type GetLocationOptions = {
  desiredAccuracy?: LocationDesiredAccuracy
  allowsBackgroundLocationUpdates?: boolean
  coordinateType?: CoordinateType
  /**
   * 是否需要带有地理编码信息。
   */
  locatingWithReGeocode?: boolean
  userId?: string
}

export type GeocodePoi = {
  uid?: string
  name?: string
  tags?: string
  addr?: string
  relaiability?: number
  directionDesc?: string
}

export type Geocode = {
  /** 国家名称 */
  country?: string

  /** 国家编码 */
  countryCode?: string

  /** 省份名称 */
  province?: string

  /** 城市名称 */
  city?: string

  /** 区名称 */
  district?: string

  /** 乡镇名称 */
  town?: string

  /** 街道名称 */
  street?: string

  /** 街道号码 */
  streetNumber?: string

  /** 城市编码 */
  cityCode?: string

  /** 行政区划编码 */
  adCode?: string

  /** 定位点周围的描述信息 */
  locationDescribe?: string

  /**
   * 周边POI信息
   */
  poiList?: GeocodePoi[]
  /**
   * 当前位置poi信息。
   */
  poi?: GeocodePoi
}

export type Location = {
  /**
   * GPS信息。
   */
  coordinate: Coordinate
  /**
   * 建筑物信息。
   */
  buildingName?: string
  /**
   * 室内定位成功后返回的楼层信息。
   */
  floorString?: string
  /**
   * 建筑物ID
   */
  buildingID?: string

  /**
   * 地理位置编码信息，当locatingWithReGeocode为true时返回。
   */
  geocode?: Geocode
  /**
   * 该定位的作弊概率。0-4分别代表无、低、中、高。
   */
  mockProbability?: number
}
