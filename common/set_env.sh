
socblox=`pwd`

while test "x$socblox" != "x" && test ! -d $socblox/common/scripts; do
  socblox=`dirname $socblox`
done

if test "x$socblox" = "x"; then
  echo "Error: Failed to find socblox root"
else
  PATH=${socblox}/common/scripts:$PATH
fi

export SOCBLOX=$socblox
export UNITS=$SOCBLOX/units
export COMMON_DIR=$SOCBLOX/common
export COMMON_RTL=$COMMON_DIR/rtl
export SYSTEMS=$SOCBLOX/systems

