#!/system/bin/sh
# Sets the product properties for the detected variant (OnePlus 8 / 8 Pro) from ro.boot.prj_version.
# OnePlus 8 (project 19855) gets the stock values: ro.product.{device,name}=OnePlus8, model and ro.build.product=IN2015.
# Other projects only get the device name; their model is left alone.

LOG=/tmp/recovery.log

set_family() {  # $1=device $2=name
    for p in "" odm. product. system. system_ext. vendor. bootimage.; do
        resetprop "ro.product.${p}device" "$1"
        resetprop "ro.product.${p}name" "$2"
    done
}

set_model() {   # $1=model
    for p in "" odm. product. system. system_ext. vendor. bootimage.; do
        resetprop "ro.product.${p}model" "$1"
    done
    resetprop "ro.build.product" "$1"
}

load_op8()    { set_family OnePlus8 OnePlus8; }
load_op8_in2015() { load_op8; set_model IN2015; }
load_op8pro() { set_family OnePlus8Pro OnePlus8Pro; }

prj=$(getprop ro.boot.prj_version)
[ -z "$prj" ] && prj=$(getprop ro.boot.prjname)
echo "unified-props: ro.boot.prj_version/prjname=$prj" >> $LOG

case "$prj" in
    19855) load_op8_in2015 ;;         # OnePlus 8 (IN2015)
    19821|19867) load_op8 ;;          # other OnePlus 8 projects
    19811) load_op8pro ;;             # OnePlus 8 Pro (not tested)
    *) echo "unified-props: unknown project '$prj', props left unchanged" >> $LOG ;;
esac
exit 0
