# device_oneplus_instantnoodle

Unified OrangeFox recovery tree for the OnePlus 8 (`instantnoodle`) and OnePlus 8 Pro (`instantnoodlep`), kona, OxygenOS 13.1.0.593.
One tree, one image for both devices; the variant is chosen at boot by `recovery/root/system/bin/runatboot.sh` from `ro.boot.prj_version`.
Goal: decrypt `/data` on the stock ROM.

**Status:** not compiled, not booted. Decryption is untested. The OnePlus 8 is the target device; the 8 Pro is untested.

## Layout
- `BoardConfig.mk`, `device.mk`, `ofox_instantnoodle.mk`, `AndroidProducts.mk`, `Android.mk`, `Android.bp`, `vendorsetup.sh`, `system.prop`, `ofox.dependencies`
- `recovery/root/` - init rc files, ueventd, `recovery.fstab`, `twrp.flags`, vintf manifests, `runatboot.sh`
- `prebuilt/` - `Image`, `dtb.img`, `dtbo.img`
- `bootctrl/`, `gpt-utils/` - module definitions used by `device.mk`
- `extract-files.sh`, `proprietary-files-recovery.txt`, `proprietary-files-recovery.sha256` - pull the decryption blobs from the phone
- `.github/workflows/build-orangefox.yml` - build in GitHub Actions

## Build
1. Get the stock decryption blobs into `recovery/root`. On the phone (stock OOS 13.1.0.593 booted), in Termux with root, from this folder: `bash extract-files.sh local`.
   Other ways: `./extract-files.sh adb` or `./extract-files.sh dir <ROOT>`. Every copied file is checked against the stock hashes (`HASHDIFF` = different firmware); `MISSING` = a required file was not found.
2. Commit everything and push. Keep the repository **private**: the blobs are OnePlus/Qualcomm files.
3. Run the workflow, or build locally with the OrangeFox 12.1 manifest: copy this folder to `device/oneplus/instantnoodle`, then
   `source build/envsetup.sh && lunch ofox_instantnoodle-eng && mka recoveryimage`.
4. Test with `fastboot boot recovery.img` before flashing anything.

## Prebuilt files
All three come from the TropsPk/Tropsi-Builder release `1794145644`, `instantnoodle-oxygen13.1_a13_Tropsi_X_noroot-20261108134644-AnyKernel3.zip` (sha256 `e56b4c63ff6e49e981efd090ff501421b6553ba9dc50da3535b20c8aaa5f8c3b`).

| File | sha256 |
|---|---|
| `Image` | `05ad91f1e5ddfd95cdbe2f458f17f1f0ee6c892b425b82c0628e4b74d655ec53` |
| `dtb.img` (zip: `dtb`) | `90013c5fc39ac520c22601cbe556f1ffe38aca092bc1f520146be509e85884ee` |
| `dtbo.img` | `afd49d1077bf92139f5172f0a7ee126c0c3c8209951872b0fd330b13bf21bfe7` |

The dtb holds 6 SoC entries and the dtbo 6 overlays, including project 19855 (OnePlus 8) and 19811 (OnePlus 8 Pro).

## Notes
- Patch level: `BoardConfig.mk` reports the real stock level (13 / 2024-06-05) to keymaster. The commented far-future values are a last resort: they may make keymaster upgrade your key blobs to a newer patch level, and stock Android could then fail to unlock `/data`. Back up first, and only try them if decryption fails with a key-upgrade error.
- `android.hardware.keymaster@4.0.so` is not shipped in `recovery/root`; the build provides it (TWRP 12.1 adds it to the ramdisk when `TW_INCLUDE_CRYPTO_FBE` is set). Both the keymaster 4.0 service and `keymasterd` need it, so the workflow checks that it is in the built ramdisk and warns if not.
- `vendor.keymasterd` is shipped disabled; start it by hand (`adb shell start vendor.keymasterd`) to test whether decryption needs it.

## Credits and licences
- LineageOS `android_device_oneplus_instantnoodle` and `sm8250-common` (Apache-2.0): board and product values.
- TeamWin `android_device_oneplus_instantnoodle` (android-13, Apache-2.0): USB rc, FBE flags.
- Wishmasterflo `device_oneplus_opkona` (android-13-14, **GPL-3.0**): recovery module lists, rc service layout, OrangeFox flags, `ashmemd.rc`, `ofox.dependencies`, workflow structure. Keep this credit if you distribute.
- SENSEIIIII `twrp_device_OnePlus_instantnoodlep`: consulted for 8 Pro differences; no files copied.
- `bootctrl/Android.bp`, `gpt-utils/Android.bp`, `task_profiles.json`, `event-log-tags`, `otacerts.zip`, `sepcialkeys.zip`: AOSP/TWRP files, identical in the reference trees. `ueventd.qcom.rc` is the stock Qualcomm file (BSD-3-Clause header kept).
- Tropsi X kernel, dtb and dtbo: GPL-2.0 artifacts.
- Project licence: GPL-3.0, see `LICENSE`.
