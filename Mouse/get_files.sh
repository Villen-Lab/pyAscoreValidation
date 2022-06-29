FTP_LINK=https://phosphomouse.hms.harvard.edu/data/Phosphorylation/Brain_Phosphorylation/
FILE_LIST=(o05794.RAW
           o05795.RAW
           o05796.RAW
           o05797.RAW
           o05799.RAW
           o05800.RAW
           o05801.RAW
           o05802.RAW
           o05807.RAW
           o05808.RAW
           o05809.RAW
           o05810.RAW
           o05811.RAW
           o05813.RAW
           o05814.RAW
           o05815.RAW
           o05816.RAW
           o05817.RAW
           o05820.RAW
           o05821.RAW
           o05822.RAW
           o05823.RAW
           o05824.RAW
           o05826.RAW
           o05827.RAW
           o05828.RAW
           o05829.RAW
           o05830.RAW)

for FILE in "${FILE_LIST[@]}"
do
    if [ ! -f $FILE ]; then
        wget $FTP_LINK/$FILE $FILE
    fi
done
