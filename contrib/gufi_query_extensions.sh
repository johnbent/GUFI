#! /bin/bash

THREADS=224
INDEX=/mnt/nvme3n1/jbent/jbent_home/

gufi_query -d " " -n "${THREADS}" "${INDEX}" \
    -I "CREATE TABLE intermediate(ext TEXT, count INTEGER);" \
    -E "INSERT INTO intermediate SELECT name AS ext, COUNT(inode) FROM vrpentries GROUP BY ext LIMIT 2;" \
    -K "CREATE TABLE aggregate(ext TEXT, count INTEGER);" \
    -J "INSERT INTO aggregate SELECT ext,count(*) FROM intermediate" \
    -G "SELECT ext, SUM(count) FROM aggregate GROUP BY ext;"


run_ext=true
if $run_ext; then
    echo "Simple select query"
    gufi_query -d " " -n "${THREADS}" "${INDEX}" \
        -E "SELECT \
                pinode, \
                CASE \
                    WHEN name NOT LIKE '%.%' THEN 'NULL'\
                    ELSE REPLACE(name, RTRIM(name, REPLACE(name, '.', '')), '')\
                END AS extension,\
                COUNT(*) AS count\
                FROM vrpentries\
                GROUP BY pinode,extension\
                ORDER BY count DESC LIMIT 4;\
            "
else
    echo "Not running simple select with replace yet"
fi

run_complex=false
if $run_complex; then
    echo "Harder fuller query"
    gufi_query -d " " -n "${THREADS}" "${INDEX}" \
        -I "CREATE TABLE intermediate(ext TEXT, count INTEGER);" \
        -E "INSERT INTO intermediate SELECT REPLACE(name, RTRIM(name, REPLACE(name, \".\", \"\")), \"\") AS ext, COUNT(inode) FROM vrpentries GROUP BY ext;" \
        -K "CREATE TABLE aggregate(ext TEXT, count INTEGER);" \
        -J "INSERT INTO aggregate SELECT ext, SUM(count) FROM intermediate GROUP BY ext;" \
        -G "SELECT ext, SUM(count) FROM aggregate GROUP BY ext;"
else
    echo "Not running complex query yet"
fi
