#!/usr/bin/env bash

#check for right number of arguments
if [ "$#" -lt 2 ]; then
echo "sorry, wrong number of arguments. Enter: size of disk and file size"
exit 1
fi

log_dir="./log"
main_dir="./backup"
test_file_size_mb="${2:-50}" #size of each test file

#create a virtual disk 
function create_disk() {
    local size_of_disk="$1"
    ./create_vd_script.sh "$size_of_disk"
}

#clean directories before the runnig test
clean() {
    echo "preparing for tests: cleaning  $log_dir and $main_dir..."
    rm -rf "$log_dir" "$main_dir"
    mkdir -p "$log_dir" "$main_dir"
    echo "everything is done - folders are cleaned up"
}



#generating files for tests
function generate_data() {
    local folder_size_mb="$1"
    local file_count=$((folder_size_mb / test_file_size_mb))
    echo "generation $file_count files $test_file_size_mb MB each in the $log_dir directory..."

    for i in $(seq 1 "$file_count"); do
        dd if=/dev/zero of="$log_dir/logfile$i.log" bs=1M count="$test_file_size_mb" status=none
        sleep 0.1
    done
}

#run main script for archivation
run_main() {
    local threshold="$1"
    local n_files="${2:-5}"
    echo "starting test: max = $threshold%, archieve $n_files files"
    ./main_script.sh "$log_dir" "$threshold" "$n_files"
    local archived_files=$(tar -tzf "$main_dir"/*.tar.gz 2> /dev/null | wc -l)
    echo "✓  files archieved: $archived_files"

}

#tests
run_tests() {

    echo "test 1 - check test"
    create_disk 1024 
    generate_data 500
    run_main 30 20
    
    echo "test 2 -the parameter n > number of files"
    create_disk 1536 
    generate_data folder_size_mb=1200
    run_main 70 50
    clean

    echo "test 3 - operation without arguments"
    create_disk 1024 
    generate_data folder_size_mb=600
    run_main 50
    clean

    echo "test 4 - treshold is exceeded"
    create_disk 1024
    generate_data 900
    run_main 80 10
    clean
}

#run tests
clean
run_tests

