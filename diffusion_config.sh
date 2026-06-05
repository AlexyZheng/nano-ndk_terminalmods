# Diffusion Installer Config
# osm0sis @ xda-developers

INST_NAME="Nano Installer Script";
AUTH_NAME="osm0sis @ xda-developers";

USE_ARCH=true
USE_ZIP_OPTS=true

custom_setup() {
  return # stub
}

custom_zip_opts() {
  return # stub
}

custom_target() {
  # use /product/bin/nano if /system_ext/bin/nano exists to remain higher in $PATH
  if [ -e /system/system_ext/bin/nano ]; then
    TARGET=$TARGET/product;
  fi;
}

custom_install() {
  ui_print " ";
  set_perm 0 0 755 $BIN/nano $BIN/nano.bin-arm $BIN/nano.bin-arm64 $BIN/nano.bin-x86_64;
  
  case $ARCH in
    arm64)
      if [ -f $BIN/nano.bin-arm64 ] && $BIN/nano.bin-arm64 --version >/dev/null 2>&1; then
        ui_print "Installing nano (arm64) to $BIN ...";
        mv -f $BIN/nano.bin-arm64 $BIN/nano.bin;
        rm -f $BIN/nano.bin-arm $BIN/nano.bin-x86_64;
      else
        ui_print "Failed to verify arm64 binary!";
        abort;
      fi;
      ;;
    arm)
      if [ -f $BIN/nano.bin-arm ] && $BIN/nano.bin-arm --version >/dev/null 2>&1; then
        ui_print "Installing nano (arm) to $BIN ...";
        mv -f $BIN/nano.bin-arm $BIN/nano.bin;
        rm -f $BIN/nano.bin-arm64 $BIN/nano.bin-x86_64;
      else
        ui_print "Failed to verify arm binary!";
        abort;
      fi;
      ;;
    x86_64)
      if [ -f $BIN/nano.bin-x86_64 ] && $BIN/nano.bin-x86_64 --version >/dev/null 2>&1; then
        ui_print "Installing nano (x86_64) to $BIN ...";
        mv -f $BIN/nano.bin-x86_64 $BIN/nano.bin;
        rm -f $BIN/nano.bin-arm $BIN/nano.bin-arm64;
      else
        ui_print "Failed to verify x86_64 binary!";
        abort;
      fi;
      ;;
    x86)
      # x86 devices can fall back to arm binary as a compatibility measure
      if [ -f $BIN/nano.bin-arm ] && $BIN/nano.bin-arm --version >/dev/null 2>&1; then
        ui_print "Installing nano (arm - compatibility fallback for x86) to $BIN ...";
        mv -f $BIN/nano.bin-arm $BIN/nano.bin;
        rm -f $BIN/nano.bin-arm64 $BIN/nano.bin-x86_64;
      else
        ui_print "Failed to verify arm binary for x86 fallback!";
        abort;
      fi;
      ;;
    *)
      ui_print "Unsupported architecture: $ARCH";
      abort;
      ;;
  esac;
  
  ui_print "Installing terminfo to $ETC ...";
  if ! $BOOTMODE; then
    ui_print "Installing nano recovery script to /sbin ...";
    cp -rf sbin/* /sbin;
    set_perm 0 0 755 /sbin/nano;
  fi;
}

custom_postinstall() {
  return # stub
}

custom_uninstall() {
  return # stub
}

custom_postuninstall() {
  return # stub
}

custom_cleanup() {
  return # stub
}

custom_exitmsg() {
  if ! $BOOTMODE && [ "$ACTION" == installation ]; then
    ui_print " ";
    ui_print "nano may now be run temporarily from";
    ui_print "terminal/adb shell for this recovery session,";
    ui_print "and from now on in booted Android.";
  fi;
}

# additional custom functions
