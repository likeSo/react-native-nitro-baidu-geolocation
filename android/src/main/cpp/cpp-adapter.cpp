#include <jni.h>
#include "NitroBaiduGeolocationOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::nitrobaidugeolocation::initialize(vm);
}
