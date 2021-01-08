
MINIMIZE_INTERMEDIATES=0
NDK_VERSION=21.2.6472646
JUCE_DIR=$(shell pwd)/external/JUCE
PROJUCER_BIN_LINUX=$(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile/build/Projucer
PROJUCER_BIN_DARWIN=$(JUCE_DIR)/extras/Projucer/Builds/MacOSX/build/Debug/Projucer.app/Contents/MacOS/Projucer
GRADLE_TASK=build

ifeq ($(shell uname), Linux)
	PROJUCER_BIN=$(PROJUCER_BIN_LINUX)
else
ifeq ($(shell uname), Darwin)
	PROJUCER_BIN=$(PROJUCER_BIN_DARWIN)
else
	PROJUCER_BIN=___error___
endif
endif


.PHONY:
all: build

.PHONY:
build: prepare build-aap build-samples

.PHONY:
prepare: build-projucer

.PHONY:
build-projucer: $(PROJUCER_BIN)

$(PROJUCER_BIN_LINUX):
	make -C $(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile
	if [ $(MINIMIZE_INTERMEDIATES) ] ; then \
		rm -rf $(JUCE_DIR)/extras/Projucer/Builds/LinuxMakefile/build/intermediate/ ; \
	fi

$(PROJUCER_BIN_DARWIN):
	xcodebuild -project $(JUCE_DIR)/extras/Projucer/Builds/MacOSX/Projucer.xcodeproj
	if [ $(MINIMIZE_INTERMEDIATES) ] ; then \
		rm -rf $(JUCE_DIR)/extras/Projucer/Builds/MacOSX/build/intermediate/ ; \
	fi

.PHONY:
build-aap:
	cd external/android-audio-plugin-framework && make MINIMIZE_INTERMEDIATES=$(MINIMIZE_INTERMEDIATES)

.PHONY:
build-samples: build-augene

.PHONY:
dist:
	mkdir -p release-builds
	mv  apps/AugenePlayer/Builds/Android/app/build/outputs/apk/release_/release/app-release_-release.apk  release-builds/AugenePlayer-release.apk


.PHONY:
build-augene: create-patched-augene do-build-augene
.PHONY:
do-build-augene:
	echo "PROJUCER is at $(PROJUCER_BIN)"
	NDK_VERSION=$(NDK_VERSION) APPNAME=AugenePlayer PROJUCER=$(PROJUCER_BIN) ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) SKIP_METADATA_GENERATOR=1 GRADLE_TASK=$(GRADLE_TASK) aap-juce/build-sample.sh apps/AugenePlayer/AugenePlayer.jucer

.PHONY:
create-patched-augene: apps/AugenePlayer/.stamp 

apps/AugenePlayer/.stamp: \
		external/augene/augene-player/** \
		apps/override.AugenePlayer.jucer \
		aap-juce/sample-project.*
	aap-juce/create-patched-juce-app.sh  AugenePlayer  external/augene/augene-player \
		apps/AugenePlayer  ../aap-augene-player.patch 2  apps/override.AugenePlayer.jucer
