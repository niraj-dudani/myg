include state.g
echo
echo "================="
echo "state.g"
echo "================="
showfield /cc *
showfield /cc/dd *
showfield /cc/chan *
showfield /cc/calcium *

delete /cc

include genesis-simdump.g
echo
echo "================="
echo "genesis-simdump.g"
echo "================="
showfield /cc *
showfield /cc/dd *
showfield /cc/chan *
showfield /cc/calcium *

exit
