#!/bin/sh

##############################################################################
##                                                                          ##
## zcopy.                                                                   ##
##                                                                          ##
## zcopy.sh (C) 2012 Clemente Feo González.                                 ##
## zcopy.sh (C) 2012 Jesús Hernández Gormaz.                                ##
##                                                                          ##
##   This program is free software; you can redistribute it and/or          ##
##     modify it under the terms of the GNU General Public License as       ##
##     published by the Free Software Foundation; either version 3, or      ##
##     (at your option) any later version.                                  ##
##     This program is distributed in the hope that it will be useful,      ##
##     but WITHOUT ANY WARRANTY; without even the implied warranty of       ##
##     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         ##
##     GNU General Public License for more details.                         ##
##     You should have received a copy of the GNU General Public License    ##
##     along with this program; if not, write to the Free Software          ##
##     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.            ##
##                                                                          ##
##############################################################################

# Filetypes: add more if you want
office="doc docx xls xlsx ppt pptx mdb accdb odt odp"
images="jpg"
compressed="zip rar 7z"
music="mp3 ogg"
video="avi mpeg mpg"
other="txt iso"

# Archivo temporal con la lista de archivos a copiar
LISTA=/tmp/lista

menu_filetypes() {

retval=$(zenity  --list  \
--text "Seleccione los tipos de archivos que quiere copiar" \
--checklist \
--column "X" --column "Opcion" --column "Tipos de archivo" \
TRUE "OFFICE" "$office" \
TRUE "IMAGES" "$images" \
FALSE "COMPRESSED" "$compressed" \
FALSE "MUSIC" "$music" \
FALSE "VIDEO" "$video" \
FALSE "OTHER" "$other" \
--separator=" ")

# Si le hemos dado a cancelar o cerrar, saldremos del script
if [ -z "$retval" ] ; then
      zenity --error \
             --text="Acción Cancelada."
      exit
fi

	echo $retval | grep -q 'OFFICE'
	OUT=$?
	if  [ $OUT -eq 0 ];then
		cadena=$cadena" "$office
	fi
	 echo $retval | grep -q 'IMAGES'
        OUT=$?
        if  [ $OUT -eq 0 ];then
                cadena=$cadena" "$images
        fi
	echo $retval | grep -q 'COMPRESSED'
        OUT=$?
        if  [ $OUT -eq 0 ];then
                cadena=$cadena" "$compressed
        fi
        echo $retval | grep -q 'MUSIC'
        OUT=$?
        if  [ $OUT -eq 0 ];then
                cadena=$cadena" "$music
        fi
        echo $retval | grep -q 'VIDEO'
        OUT=$?
        if  [ $OUT -eq 0 ];then
                cadena=$cadena" "$video
        fi
        echo $retval | grep -q 'OTHER'
        OUT=$?
        if  [ $OUT -eq 0 ];then
                cadena=$cadena" "$other
        fi
}


menu_select_root(){
 	DIRECTORY_ROOT=`zenity --file-selection --directory --filename=/media/ \
			--title "Seleccione un directorio origen"`
# Si le hemos dado a cancelar o cerrar, saldremos del script
	if [ -z "$DIRECTORY_ROOT" ] ; then
      		zenity --error \
             		--text="Acción Cancelada."
      		exit
	fi
}

menu_select_target(){
        DIRECTORY_TARGET=`zenity --file-selection --directory --filename=/media/ \
                        --title "Seleccione un directorio destino"`
# Si le hemos dado a cancelar o cerrar, saldremos del script
	if [ -z "$DIRECTORY_TARGET" ] ; then
      		zenity --error \
             	--text="Acción Cancelada."
      		exit
	fi
}

busqueda() {
# Buscamos un tipo de extension desde el directorio_root
find "$DIRECTORY_ROOT/" -iname "*.$i"
}

busca_y_graba(){
date +%N
# Creamos el fichero donde se guarda la ruta de  todos los archivos a copiar
echo "$LISTA" > $LISTA
# Iremos buscando cada tipo de archivo y el resultado lo metemos en la lista
for i in $cadena;
        do busqueda >> $LISTA;
done
# Guardamos los archivos de la lista en el directorio destino
rsync -av --progress --files-from=$LISTA / "$DIRECTORY_TARGET/"
# Eliminamos el fichero lista ya que es temporal
rm $LISTA
date +%N
}

menu_filetypes
menu_select_root
menu_select_target
busca_y_graba
