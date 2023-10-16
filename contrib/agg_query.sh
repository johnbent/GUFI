#! /usr/bin/env bash

ir=/mnt/nvme3n1/jbent/jbent_home/

#echo "dir filecounts as function of depth in $ir"
#gufi_query \
#    -B 4096 \
#    -I "CREATE TABLE intermediate (depth INTEGER, totfiles INTEGER, totdirs INTEGER)" \
#    -S "INSERT INTO intermediate SELECT level(), totfiles, 1 FROM vrsummary " \
#    -K "CREATE TABLE aggregate (depth INTEGER, totfiles INTEGER, totdirs INTEGER)" \
#    -J "INSERT INTO aggregate SELECT depth,totfiles,totdirs FROM intermediate GROUP BY depth" \
#    -G "SELECT depth, total(totdirs), total(totfiles), total(totfiles)/total(totdirs) FROM aggregate GROUP BY depth ORDER BY depth" \
#    -n 224 \
#    -d ' ' \
#    $ir

#echo "file sizes as function of depth in $ir using vrpentries"
#echo "skipping this one. same results and faster query to use vrsummary"
#gufi_query \ -B 4096 \ -I "CREATE TABLE intermediate (depth INTEGER, quantity INTEGER, total INTEGER)" \ -E "INSERT INTO intermediate SELECT level(), count(*), total(size) FROM vrpentries WHERE (type == 'f') GROUP BY level()" \ -K "CREATE TABLE aggregate (depth INTEGER, quantity INTEGER, total INTEGER)" \ -J "INSERT INTO aggregate SELECT * FROM intermediate " \ -G "SELECT depth, total(quantity), total(total),total(total)/total(quantity) FROM aggregate GROUP BY depth ORDER BY depth" \ -n 224 \ -d ' ' \ $ir

#echo "file sizes as function of depth in $ir using summary table"
#gufi_query \
#    -B 4096 \
#    -I "CREATE TABLE intermediate (depth INTEGER, totfiles INTEGER, totsize INTEGER)" \
#    -S "INSERT INTO intermediate SELECT level(), totfiles, totsize FROM vrsummary " \
#    -K "CREATE TABLE aggregate (depth INTEGER, totfiles INTEGER, totsize INTEGER)" \
#    -J "INSERT INTO aggregate SELECT * FROM intermediate " \
#    -G "SELECT depth, total(totfiles), total(totsize),total(totsize)/total(totfiles) FROM aggregate GROUP BY depth ORDER BY depth" \
#    -n 224 \
#    -d ' ' \
#    $ir
#
echo "file sizes and file counts as function of depth in $ir using summary table"
gufi_query \
    -B 4096 \
    -I "CREATE TABLE intermediate (depth INTEGER, totfiles INTEGER, totsize INTEGER, totdirs INTEGER)" \
    -K "CREATE TABLE aggregate    (depth INTEGER, totfiles INTEGER, totsize INTEGER, totdirs INTEGER)" \
    -S "INSERT INTO intermediate SELECT level(), totfiles, totsize, 1 FROM vrsummary " \
    -J "INSERT INTO aggregate SELECT * FROM intermediate " \
    -G "SELECT depth, total(totdirs), total(totfiles), total(totsize),total(totfiles)/total(totdirs), total(totsize)/total(totfiles) FROM aggregate GROUP BY depth ORDER BY depth" \
    -n 224 \
    -d ' ' \
    $ir








