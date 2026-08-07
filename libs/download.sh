download(){

url=$1

file=$2

wget -c "$url" -O "$file"

}
