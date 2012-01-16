
if [ "$2" = "$3" ] || [ -z $1 ] || [ -z $2 ]
then
  exit
fi

# Comprobamos que existe el primer parametro
if [ ${#2} != 0 ]
then
  mkdir $1/$2
  # Buscamos los directorios para lanzar procesos en segundo plano que se
  #  encarguen de ellos
  find $2 -maxdepth 1 -type f -exec cp {} $1/{} \; -exec echo {} >> $1/files \;&
  find $2 -maxdepth 1 -type d -exec $0 $1 {} $2 \;
fi
