package com.nitrobaidugeolocation

import com.baidu.location.BDAbstractLocationListener
import com.baidu.location.BDLocation
import com.baidu.location.LocationClient
import com.baidu.location.LocationClientOption
import com.margelo.nitro.NitroModules
import com.margelo.nitro.core.Promise
import com.margelo.nitro.nitrobaidugeolocation.Coordinate
import com.margelo.nitro.nitrobaidugeolocation.CoordinateType
import com.margelo.nitro.nitrobaidugeolocation.Geocode
import com.margelo.nitro.nitrobaidugeolocation.GeocodePoi
import com.margelo.nitro.nitrobaidugeolocation.GetLocationOptions
import com.margelo.nitro.nitrobaidugeolocation.HybridNitroBaiduGeolocationSpec
import com.margelo.nitro.nitrobaidugeolocation.Location

class HybridNitroBaiduGeolocation : HybridNitroBaiduGeolocationSpec() {
    private var mLocationClient: LocationClient? = null

    override fun agreePrivacyPolicy(agree: Boolean) {
        LocationClient.setAgreePrivacy(agree)
    }

    override fun initialize(ak: String): Promise<Double> {
        NitroModules.applicationContext
        this.mLocationClient = LocationClient(NitroModules.applicationContext)
        return Promise.resolved(0.0)
    }

    override fun getCurrentLocation(options: GetLocationOptions): Promise<Location> {
        val promise = Promise<Location>()
        val locOption = LocationClientOption().apply {
            locationMode = LocationClientOption.LocationMode.Hight_Accuracy
            coorType = when (options.coordinateType) {
                CoordinateType.BMK09LL -> "bd09ll"
                CoordinateType.BMK09MC -> "bd09"
                CoordinateType.WGS84 -> "wgs84"
                CoordinateType.GCJ02 -> "gcj02"
                null -> "gcj02"
            }
            isNeedPoiRegion = options.locatingWithReGeocode == true
            setIsNeedAddress(true)
        }
        mLocationClient?.locOption = locOption
        this.mLocationClient?.registerLocationListener(object : BDAbstractLocationListener() {
            override fun onReceiveLocation(loc: BDLocation?) {
                mLocationClient?.stop()

                val coordinate =
                    Coordinate(loc?.latitude ?: 0.0, loc?.longitude ?: 0.0, loc?.altitude ?: 0.0)
                val poiList = loc?.poiList?.map {
                    GeocodePoi(
                        it.id,
                        it.name,
                        it.tags,
                        it.addr,
                        it.rank,
                        null
                    )
                }
                val poiRegion = loc?.poiRegion?.let {
                    GeocodePoi(
                        it.uid,
                        it.name,
                        it.tags,
                        null,
                        null,
                        it.derectionDesc
                    )
                }
                val geocode =
                    Geocode(
                        loc?.country,
                        loc?.countryCode,
                        loc?.province,
                        loc?.city,
                        loc?.district,
                        loc?.town,
                        loc?.street,
                        loc?.streetNumber,
                        loc?.cityCode,
                        loc?.adCode,
                        loc?.locationDescribe,
                        poiList?.toTypedArray(),
                        poiRegion
                    )
                val location =
                    Location(
                        coordinate,
                        loc?.buildingName,
                        loc?.floor,
                        loc?.buildingID,
                        geocode,
                        loc?.mockGnssProbability?.toDouble()
                    )
                promise.resolve(location)
            }

        })
        mLocationClient?.start()
        return promise
    }
}
