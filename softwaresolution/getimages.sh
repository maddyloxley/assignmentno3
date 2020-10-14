#!/bin/bash 

#Maddison Loxley
#10526752

read -p "Enter the name of the directory where the images are to be downloaded: " dirname #enter directory name 

if [ -d $dirname ]; then #if it exists images will be downloaded there 
: 
else 
     mkdir $dirname #if it doesn't exist it will be created and images will be downloaded there 
fi 

webgpage="https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/DSC0" #variable for webpage 
extension=".jpg" #variable for extension 
kb=KB
post=/*

#Function to download specific image 
specthumb() {
    read -p "Enter the last 4 digits of the thumbnail you wish to download: " thumbnail
    wget - -A".jpg" https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/DSC0"$thumbnail".jpg -P $dirname #wget only jpg files with the specified thumbnail and downloaded to directory $dirname
    for f in $dirname$post
     do
     filesize=$(du -b $f | awk '{adj=$1/1024; printf "%.2f\n", adj}') #finding size of the downloaded file 
     filetotal=$(echo $filetotal $filesize | awk '{sum=$1+$2; printf "%.2f\n", sum}')
     filetotal=$(echo $filetotal | awk '{conv=$1/1024; printf "%.2f\n", $conv}') #finding size of the total number of downloaded files
     done 
echo "Downloading $thumbnail, with the file name $thumbnail$extension with a file size of $filesize$kb...Download complete"    
}

#Function to download images by range 
range() {
    read -p "Enter start range (last 4 digits): " start #enter start range
    read -p "Enter end range (last 4 digits): " end #enter end range 
   
 curl -O https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/DSC0[$start-$end].jpg --output "$dirname"
#using curl to download range of images as wget wouldn't work, curl had an issue downloading images as it wanted to download them to a file not a directory

echo "Downloading a range of files with the extension $extension with a file size of $f1size$kb...Download complete"
}

#Function to download a specific number of images 
specnum() {
    
    read -p "Enter the number of images to be downloaded: " number 
    i=shuf -i 02100-0674 #shuffle numbers between 02100 and 0674
    for (( i=1; i<=$number; i++ )) #a for loop that includes the number of images chosen to randomly produce 
    do
     wget -A "*jpg" https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/DSC0"$i".jpg -P $dirname
    done 
   #
   echo "Downloading all $extension files, total size of all the files downloaded is $filetotal$kb"

echo "Downloading selected files with the extension $extension with a file size of $f1size$kb...Download complete"
}

#Function to download ALL files
allnum() {
   wget -e robots=off -P $dirname -A "*.jpg" -i "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=ml-2018-campus" | curl -s $dirname | grep -Eo '(http|https)://[^"]+' | grep ".jpg" | sed 's/.*\///'
   #wget to grab all image files from the webpage, tried to specify just jpg images and to write out all text using said and grep but tmp files remained
   for f in $dirname$post
   do
   filesize=$(du -b $f | awk '{adj=$1/1024; printf "%.2f\n", adj}') #size of one downloaded file
   filetotal=$(echo $filetotal $filesize | awk '{sum=$1+$2; printf "%.2f\n", sum}')
   filetotal=$(echo $filetotal | awk '{conv=$1/1024; printf "%.2f\n", $conv}') #size of all downloaded files
   done 
   
   echo "Downloading all $extension files, total size of all the files downloaded is $filetotal$kb"
}

#Function to clean 
clean() {

    clean(){
    read -p "Enter the directory you'd like to clean: " dir_to_clean
    find . -name "$dir_to_clean" -type d -prune -exec rm -rf '{}' '+' #specifying directory to clean and cleaning only that directory, being careful when using rm -rf 
}

}

#Function to exit 
exitpro(){
    echo "Exiting program" #will automatically exit 
}

echo -e "FUNCTION MENU:\n[1] Download specific thumbnail\n[2] Download images by range\n[3] Download a specific number of images\n[4] Download ALL thumbnails\n[5] Clean up\n[6] Exit program"
#using a function menu to choose which function to perform 
read -p 'Please select a menu option [1, 2, 3, 4, 5 or 6]: ' selopt

case $selopt in 
   1) specthumb;;
   2) range;;
   3) specnum;;
   4) allnum;;
   5) clean;;
   6) exitpro;;
   *) echo "Invalid choice" && exit 1;;
esac

exit 0