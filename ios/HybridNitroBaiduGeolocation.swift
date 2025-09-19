//
//  HybridNitroBaiduGeolocation.swift
//  Pods
//
//  Created by  on 2025/9/12.
//

import Foundation
import BMKLocationKit
import NitroModules

class HybridNitroBaiduGeolocation: HybridNitroBaiduGeolocationSpec {
    var authDelegateProxy: AuthDelegateProxy?
    
    override init() {
        
    }
    
    func initialize(ak: String) throws -> Promise<Double> {
        let promise = Promise<Double>()
        authDelegateProxy = AuthDelegateProxy { [weak self] code in
            promise.resolve(withResult: Double(code.rawValue))
            self?.authDelegateProxy = nil
        }
        BMKLocationAuth.sharedInstance().checkPermision(withKey: ak,
                                                        authDelegate: authDelegateProxy)
        return promise
    }
    
    func agreePrivacyPolicy(agree: Bool) throws {
        BMKLocationAuth.sharedInstance().setAgreePrivacy(agree)
    }
    
    func getCurrentLocation(options: GetLocationOptions) throws -> NitroModules.Promise<Location> {
        let promise = Promise<Location>()
        
        let locationManager = BMKLocationManager()
        
        if let allowsBackgroundLocationUpdates = options.allowsBackgroundLocationUpdates {
            locationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        }
        if let desiredAccuracy = options.desiredAccuracy {
            switch desiredAccuracy.stringValue {
            case "best": locationManager.desiredAccuracy = kCLLocationAccuracyBest
            case "bestForNavigation": locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            case "nearestTenMeters": locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            case "hundredMeters": locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            case "kilometer": locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            case "threeKilometers": locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            default: break
            }
        }
        if let coordinateType = options.coordinateType {
            switch coordinateType.stringValue {
            case "bmk09ll":
                locationManager.coordinateType = .BMK09LL
            case "bmk09mc":
                locationManager.coordinateType = .BMK09MC
            case "wgs84":
                locationManager.coordinateType = .WGS84
            case "gcj02":
                locationManager.coordinateType = .GCJ02
            default:
                break
            }
        }
        
        
        let locatingWithReGeocode = options.locatingWithReGeocode ?? true
        locationManager.locatingWithReGeocode = locatingWithReGeocode
        locationManager.userID = options.userId
        
        locationManager.requestLocation(withReGeocode: locatingWithReGeocode,
                                        withNetworkState: true) { location, state, error in
            if error != nil {
                promise.reject(withError: error!)
            } else {
                let coord = Coordinate(latitude: location?.location?.coordinate.latitude ?? 0,
                                       longitude: location?.location?.coordinate.longitude ?? 0,
                                       altitude: location?.location?.altitude ?? 0)
                let poiList = location?.rgcData?.poiList?.map { poi in
                    return GeocodePoi(uid: poi.uid,
                                      name: poi.name,
                                      tags: poi.tags,
                                      addr: poi.addr,
                                      relaiability: Double(poi.relaiability),
                                      directionDesc: nil)
                }
                let poi = location?.rgcData?.poiRegion.map { region in
                    return GeocodePoi(uid: nil,
                                      name: region.name,
                                      tags: region.tags,
                                      addr: nil,
                                      relaiability: nil,
                                      directionDesc: region.directionDesc)
                }
                let geocode = Geocode(country: location?.rgcData?.country,
                                      countryCode: location?.rgcData?.countryCode,
                                      province: location?.rgcData?.province,
                                      city: location?.rgcData?.city,
                                      district: location?.rgcData?.district,
                                      town: location?.rgcData?.town,
                                      street: location?.rgcData?.street,
                                      streetNumber: location?.rgcData?.streetNumber,
                                      cityCode: location?.rgcData?.cityCode,
                                      adCode: location?.rgcData?.adCode,
                                      locationDescribe: location?.rgcData?.locationDescribe,
                                      poiList: poiList,
                                      poi: poi)

                let location = Location(coordinate: coord,
                                        buildingName: location?.buildingName,
                                        floorString: location?.floorString,
                                        buildingID: location?.buildingID,
                                        geocode: geocode,
                                        mockProbability: Double(location?.mockProbability.rawValue ?? 0))
                promise.resolve(withResult: location)
            }
        }
        
        return promise
    }
}

class AuthDelegateProxy: NSObject, BMKLocationAuthDelegate {
    fileprivate let onResult: ((_ result: BMKLocationAuthErrorCode) -> Void)?
    
    init(onResult: @escaping (_: BMKLocationAuthErrorCode) -> Void) {
        self.onResult = onResult
    }
    
    
    func onCheckPermissionState(_ iError: BMKLocationAuthErrorCode) {
        self.onResult?(iError)
    }
}
