
# path to application repo. The default is the submodule path.
APP_SRC_DIR=$(shell pwd)/external/augene/augene-player
# base app name
APP_NAME=AugenePlayer
# app build directory name. Usually repo name is good.
APP_BUILD_DIR=apps/AugenePlayer
# diff file to app, generated by git diff. "-" if there is no patch.
PATCH_FILE=$(shell pwd)/apps/aap-augene-player.patch
# diff depth, depending on the nested directory in the source tree, if patch exists.
PATCH_DEPTH=2
# 1 if it should skip metadata generator. Plugins need it, hosts don't.
SKIP_METADATA_GENERATOR=1 

include aap-juce/Makefile.common

