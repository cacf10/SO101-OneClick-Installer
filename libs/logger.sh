LOGFILE=logs/install.log

mkdir -p logs

log(){

echo "$(date '+%F %T') $1" >> $LOGFILE

}
